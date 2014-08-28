//
//  RESTAPIHandler.h
//  Lenscapp
//
//  Automatic hashtag suggestions for your social media posts
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



#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


// Service API link
// http://apitest.lenscapp.com is the test URL
// http://api.lenscapp.com is production URL
#define k_REST_API_URL @"http://apitest.lenscapp.com:8080/gtg/services/keywords/find?userEmail=%@&appKey=%@&format=&apiSig=%@&latitude=%lf&longitude=%lf&scope=&withEvents=true&date=%@&keywords=&verbose=true"

// CONST defined variable
// Test appKey and user
// Please contact support@lenscapp.com to get your free appKey and login
#define k_appKey        @"3fa859b9ee166d318b438c77bc382164"
#define k_userEmail     @"admin@email.com"
#define k_apiSig        @"admin123"

#define k_iPad (UI_USER_INTERFACE_IDIOM())
#define k_iPhone5 [[UIScreen mainScreen]bounds].size.height>480


@interface RESTAPIHandler : NSObject <CLLocationManagerDelegate>

/*** getting user location ***/
@property (nonatomic, strong) CLLocationManager *locationManager;

/*** Data Holder for user selected image metadata (creation date & location) ***/
@property (strong, nonatomic) NSMutableArray *photoData;

/*** Data Holder for User's Current location and device current date ***/
@property (strong, nonatomic) NSMutableArray *userData;

/*** Singleton Instance Method for this class ***/
+ (RESTAPIHandler*)shareHandler;

/*** For Getting Hash Tag corresponding to User Data ***/
- (void)getHashTagForUser;

/*** For Getting Hash Tag corresponding to Shared Image Data ***/
- (void)getRawDataForSharedImage;

/*** Return (#)hash tags from server to share service ***/
- (NSArray*)hasTagsFromRESTAPI;
@end


/* Documentation of this class */

/*
 
 For using this class you have to add these file to your project
 
 RESTAPIHandler.h
 RESTAPIHandler.m
 JSONKit.h
 JSONKit.m
 
 Then Import RESTAPIHandler.h
 
 Add this line into your source
 
 // RESTAPI calling
 [[RESTAPIHandler shareHandler]getHashTagForUser];
 
 To get the hashtag array call this line
 
 NSArray *hashTags = [[RESTAPIHandler shareHandler]hasTagsFromRESTAPI];
 
 */








