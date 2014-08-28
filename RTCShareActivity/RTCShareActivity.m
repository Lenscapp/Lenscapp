//
//  RTCShareActivity.m
//  Helps auto-populate text when sharing on social networks
//
//  Created by Hafizur Rahman on 4/10/14.
//  Copyright (c) 2014 RTC Hubs Limited. All rights reserved.
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


#import "RTCShareActivity.h"
#import "RTCActivityProvider.h"


@implementation RTCShareActivity

-(id)initWithFacebookText:(NSString *)faceBookText twitterText:(NSString *)twitterText otherText:(NSString *)otherText withMailSubject:(NSString *)mailSubjects{
    
    self.facebookText = faceBookText;
    self.twitterText = twitterText;
    self.emailText = otherText;
    self.subject = mailSubjects;
    return self;
}

-(void)shareWith:(NSURL *)sharingurl image:(UIImage *)image fromViewController:(UIViewController *)viewController filePath:(NSString*)filePath{

    RTCActivityProvider *activityProvider = [[RTCActivityProvider alloc] init];
    
    activityProvider.fbText = _facebookText;
    activityProvider.twitterText = _twitterText;
    activityProvider.mailText = _emailText;
    activityProvider.smsText = _twitterText;
    activityProvider.mailSubject = _subject;
    //activityProvider.bcc = @"feedback.us@gmail.com";
    
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    [items addObject:activityProvider];
    
    if (filePath)
        [items addObject:[NSURL fileURLWithPath:filePath]];
    
    if (sharingurl)
        [items addObject:sharingurl];
    
    if (image)
        [items addObject:image];
    
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc]
                                               initWithActivityItems:items
                                               applicationActivities:nil];
    
    
    if ([[[UIDevice currentDevice]systemVersion] intValue]<7)
        [activityView setValue:_subject forKey:@"subject"];
    
    
    [activityView setExcludedActivityTypes:
     @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage]];
    

    
    [viewController presentViewController:activityView animated:YES completion:nil];
    
    [activityView setCompletionHandler:^(NSString *act, BOOL done)
     {
         NSString *ServiceMsg = nil;
         if ( [act isEqualToString:UIActivityTypeMail] )           ServiceMsg = @"Mail sent!";
         if ( [act isEqualToString:UIActivityTypePostToTwitter] )  ServiceMsg = @"Post on Twitter, Ok!";
         if ( [act isEqualToString:UIActivityTypePostToFacebook] ) ServiceMsg = @"Post on Facebook, Ok!";
         if ( [act isEqualToString:UIActivityTypeMessage] )        ServiceMsg = @"SMS sent!";
         if ( done )
         {
             UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:ServiceMsg message:@"Successful!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
             [Alert show];
         }
     }];
}

@end
