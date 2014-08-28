//
//  RTCActivityProvider.m
//  Connects to social networks
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


#import "RTCActivityProvider.h"

@implementation RTCActivityProvider

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
        return _twitterText;
    
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return _fbText;
    
    if ( [activityType isEqualToString:UIActivityTypeMessage] )
        return _smsText;
    
    if ( [activityType isEqualToString:UIActivityTypeMail] ){
        _mailText = [@"<html><body>" stringByAppendingString:_mailText];
        _mailText = [_mailText stringByAppendingString:@"</body></html>"];
        

        return _mailText;
    }
    
    
    if ( [activityType isEqualToString:@"RTC Hubs Limited"] )
        return @"See More from RTC Hubs Limited";
    
    return nil;
}

- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController { return @""; }


- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType{

    if ( [activityType isEqualToString:UIActivityTypeMail] ){
        
        return _mailSubject;
    }
    else
        return nil;
}


@end



/*
@implementation APActivityIcon

- (NSString *)activityType { return @"RTC Hubs Limited"; }

- (NSString *)activityTitle { return @"More"; }

- (UIImage *) activityImage { return [UIImage imageNamed:@"Icon.png"]; }

- (BOOL) canPerformWithActivityItems:(NSArray *)activityItems { return YES; }

- (void) prepareWithActivityItems:(NSArray *)activityItems { }

- (UIViewController *) activityViewController { return nil; }

- (void) performActivity {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rtchubs.com"]];
}
@end
 */

