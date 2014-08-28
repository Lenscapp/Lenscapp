//
//  RESTAPIHandler.m
//  Lenscapp
//
//  Automatic hashtag suggestions for your social media connections
//
//  Created by Hafizur Rahman on 7/10/14.
//  Copyright (c) 2014 Lenscapp.com. All rights reserved.
//
/*
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */


#import "RESTAPIHandler.h"
#import "JSONKit.h"


/*** Category class of RESTAPIHandler ***/

@interface RESTAPIHandler ()

@property (nonatomic, strong) NSString *currentDateTime;
@property (nonatomic) CLLocationCoordinate2D currentCoordinate;

@property (nonatomic, strong) NSArray *hashTagArray;
@end


/*** Singleton instance of RESTAPIHandler ***/
static RESTAPIHandler *sharedHandler = nil;

@implementation RESTAPIHandler


/* Get singleton Instance of RESTAPIHandler */

+ (RESTAPIHandler*)shareHandler{

    if (!sharedHandler){
    
        sharedHandler = [[RESTAPIHandler alloc]init];
    }
    return sharedHandler;
}

- (void)getHashTagForUser{
    
    if (!self.photoData)
        self.photoData = [[NSMutableArray alloc]init];
    if (!self.userData)
        self.userData = [[NSMutableArray alloc]init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
    BOOL locationServieIsEnable = [CLLocationManager locationServicesEnabled];
    
    if (locationServieIsEnable) {
        
        [self.locationManager startUpdatingLocation];
    }
    else{
        NSLog(@"Please On Your Location Service...");
    }
}

- (void)getRawDataForSharedImage{

    [self getRawDataFromRESTAPIServer:self.photoData];
}

- (NSArray*)hasTagsFromRESTAPI{

    return (self.hashTagArray.count)?self.hashTagArray:nil;
}


/*** stop updating location ***/

-(void)stopUpdatingLocation{
    
    // Stop updating location of the device to conserve battery
    [self.locationManager stopUpdatingLocation];
}


#pragma Mark Lcation manager delegate method

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Remove previous data is have any
        [self.userData removeAllObjects];
        
        // Add current location to user data array
        [self.userData addObject:manager.location];
        
        // Add current date-time to user data array
        [self.userData addObject:[NSDate date]];

        // Get the current latitude & longtitude to hold on the global variable
        _currentCoordinate = manager.location.coordinate;
        
        // REST API service calling
        [self getRawDataFromRESTAPIServer:self.userData];
    });
    
    
    [self stopUpdatingLocation];
}


- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@",error.localizedDescription);
    
    if ([error code] == kCLErrorLocationUnknown) {
        
        [self stopUpdatingLocation];
    }
}


- (void)getRawDataFromRESTAPIServer:(NSArray*)metaDataArray{

    
    if (metaDataArray.count >= 2){
    }
    else{
        NSLog(@"data not found");
    }
    
    // Initialize date formatter to get the date-time as expected format
    NSDateFormatter *formtter = [[NSDateFormatter alloc] init];
    
    [formtter setDateStyle:NSDateFormatterFullStyle];
    
    [formtter setDateFormat:@"yyyy-MM-dd+HH:mm:ss"];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 0.00f;
    coordinate.longitude = 0.00f;
    
    NSDate *date = nil;
    CLLocation *location = nil;
    
    if (metaDataArray.count > 0){
        
        for (id obj in metaDataArray){
            
            if ([obj isKindOfClass:NSClassFromString(@"NSDate")]){
                
                date = obj;
                self.currentDateTime = [formtter stringFromDate:date];
                
            }
            if ([obj isKindOfClass:NSClassFromString(@"CLLocation")]) {
                
                location = obj;
                coordinate = location.coordinate;
            }
        }
    }else{
        coordinate = _currentCoordinate;
        self.currentDateTime = [formtter stringFromDate:[NSDate date]];
    }
    
    
    
    NSLog(@"current date time: %@\n Coordinate: %lf %lf", self.currentDateTime, coordinate.latitude, coordinate.longitude);
    
    NSString *queryString = [NSString stringWithFormat:@"%@", k_REST_API_URL];
    
    queryString = [NSString stringWithFormat:queryString,k_userEmail,k_appKey,k_apiSig,coordinate.latitude,coordinate.longitude,self.currentDateTime];
    
    queryString = [queryString stringByAddingPercentEscapesUsingEncoding:1];
    
    NSLog(@"queryString: %@", queryString);
    
    
    // URL request to REST API
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:queryString]];

    // Sending URL request to REST API using asynchrounous method which does not block current device UI
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // If not getting any error from this link parse the data and get HASH (#) tag to an array
        if (data.length > 0){
        
            NSString *resultString = [[NSString alloc]initWithData:data encoding:1];
            
            // Parsing JSON data and assign to a dictionary
            NSDictionary *resultDic = [resultString objectFromJSONString];
            
            // Assign the HASH tag array to global variable on a main thread coz URL request is called in background thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([resultDic objectForKey:@"HASHTAGS"]){
                    
                    self.hashTagArray = [NSArray arrayWithArray:[resultDic objectForKey:@"HASHTAGS"]];
                    //NSLog(@"Array: %@", self.hashTagArray);
                }
            });
        }
    }];
}

@end
