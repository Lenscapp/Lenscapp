//
//  RTCActivityProvider.h
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


#import <UIKit/UIKit.h>

@interface RTCActivityProvider : UIActivityItemProvider <UIActivityItemSource>

@property (nonatomic, strong) NSString *fbText;
@property (nonatomic, strong) NSString *mailText;
@property (nonatomic, strong) NSString *twitterText;
@property (nonatomic, strong) NSString *smsText;
@property (nonatomic, strong) NSString *mailSubject;
@property (nonatomic, strong) NSString *bcc;



@end

/*
@interface APActivityIcon : UIActivity
@end
*/