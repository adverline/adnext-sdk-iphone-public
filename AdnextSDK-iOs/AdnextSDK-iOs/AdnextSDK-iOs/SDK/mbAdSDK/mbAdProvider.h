//  mbAdProvider.h
//  MisterBell Solutions Advertising SDK
//
//  Created by Mickaël Gentil on 6/1/2012.
//  Copyright 2012 MisterBell Solutions. All rights reserved.
//
//  This source is subject to the MisterBell Solutions Permissive License.
//  Please see the License.txt file for more information.
//  All other rights reserved.
//
//  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY 
//  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//  PARTICULAR PURPOSE.
//

@protocol mbAdViewProtocol <NSObject>

@optional

// called when an ad fails to load
- (void)failureLoadingAd:(UIView *)adView;

// Called just before to an ad is displayed
- (void)adWillShow:(UIView *)adView;

// Called just after to an ad is displayed
- (void)adDidShow:(UIView *)adView;

// Called just before an ad closes
- (void)adWillClose:(UIView *)adView;

// Called just after an ad closes
- (void)adDidClose:(UIView *)adView;

@end


@interface mbAdProvider : NSObject

- (id) init;
+ (id) sharedInstance;

- (void) clean:(int)_num;

- (int) startWithSlot:(NSString *)slot delegate:(id<mbAdViewProtocol>)_delegate attachTo:(UIView *)_attachTo location:(CGPoint)_location;
- (int) startWithSlot:(NSString *)slot delegate:(id<mbAdViewProtocol>)_delegate;
- (int) startWithSlot:(NSString *)slot location:(CGPoint)_location;
- (int) startWithSlot:(NSString *)slot attachTo:(UIView *)_attachTo;
- (int) startWithSlot:(NSString *)slot delegate:(id<mbAdViewProtocol>)_delegate attachTo:(UIView *)_attachTo;
- (int) startWithSlot:(NSString *)slot delegate:(id<mbAdViewProtocol>)_delegate location:(CGPoint)_location;
- (int) startWithSlot:(NSString *)slot attachTo:(UIView *)_attachTo location:(CGPoint)_location;
- (int) startWithSlot:(NSString *)slot attachTo:(UIView *)_attachTo delegate:(id<mbAdViewProtocol>)_delegate;

@end