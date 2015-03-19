//
//  AdvMisterBellProvider.m
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 02/06/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//

#import "AdvMisterBellProvider.h"
#import "mbAdProvider.h"
#import "AdvAdView.h"

@interface AdvMisterBellProvider () <mbAdViewProtocol>

@property (nonatomic, assign) BOOL isInterstitial;
@property (nonatomic, weak) UIView *contentView;

@end

@implementation AdvMisterBellProvider

- (void)loadAdForView:(UIView *)view forAdId:(NSString*)adId andRootController:(UIViewController*)rootController
{
//    adId = @"RvTkRS4WFt6J8EtCt9x23VtsUI9y-c0UKf9cotac2pQpw0shXo_xWLw8GW7ep1Jfh1Ac6kY7ZGpjnCy7iqpRTQ";
    

  //  adId = @"4e9jKVFXqLc3Hr86JGE67eMSXHkBdqr9sIDGEZFOkotKSVM3rjFNTNdYol9aUw1z08z_W2E7pgnso6DC5B5sKQ";
    
    self.contentView = view;

    [[mbAdProvider sharedInstance] startWithSlot:adId delegate:self attachTo:view location:CGPointMake(0, view.frame.size.height - 50)];
//    CGRect frame = view.frame;
//    frame.size.height = 50.f;
//    view.frame = frame;
  //  [[mbAdProvider sharedInstance] startWithSlot:adId delegate:self attachTo:view location:CGPointMake(0, 0)];
  //  [[mbAdProvider sharedInstance] startWithSlot:adId location:CGPointMake(0.0, 0.0)];
}

- (void)loadInterstitialForView:(UIView *)view forAdId:(NSString*)adId andRootController:(UIViewController*)rootController
{
    self.isInterstitial = TRUE;
    
 //   [[mbAdProvider sharedInstance] startWithSlot:adId delegate:self];
       [[mbAdProvider sharedInstance] startWithSlot:adId delegate:self attachTo:[UIApplication sharedApplication].windows[0]];
}

- (void)failureLoadingAd:(UIView *)adView
{
//    NSLog(@"FAILURE");
    if ([self.adView.delegate respondsToSelector:@selector(adLoadingFailed:)])
        [self.adView.delegate adLoadingFailed:self.adView];
}

- (void)adWillShow:(UIView *)adView
{
    
}

- (void)adDidShow:(UIView *)adView
{
    if ([self.adView.delegate respondsToSelector:@selector(adShown:)])
        [self.adView.delegate adShown:self.adView];
    
    if (!self.isInterstitial)
    {
        CGRect frame = adView.frame;
        
        frame.origin.y = self.contentView.frame.size.height - 50;
        frame.size.height = 50;
        
        adView.superview.frame = frame;
    }
}

- (void)adWillClose:(UIView *)adView
{
    
}


- (void)adDidClose:(UIView *)adView
{
    if ([self.adView.delegate respondsToSelector:@selector(adClosed:)])
        [self.adView.delegate adClosed:self.adView];
}

@end
