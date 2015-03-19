//
//  AdvAdMobProvider.m
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 02/06/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//

#import "AdvAdMobProvider.h"

#import "GADBannerView.h"
#import "GADInterstitial.h"
#import "AdvAdView.h"

@interface AdvAdMobProvider () <GADInterstitialDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) GADInterstitial *interstitialView;

@property (nonatomic, weak) UIViewController *rootController;

@end

@implementation AdvAdMobProvider

- (void)loadAdForView:(UIView *)view forAdId:(NSString*)adId andRootController:(UIViewController*)rootController
{
    self.rootController = rootController;
    
    GADAdSize size = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? (kGADAdSizeFullBanner) : (kGADAdSizeBanner);
    CGPoint origin = CGPointMake(0.0,
                                 view.frame.size.height -
                                 CGSizeFromGADAdSize(size).height);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.bannerView = [[GADBannerView alloc] initWithAdSize:size origin:origin];
    
    self.bannerView.adUnitID = adId;
    
   // self.bannerView.delegate = self;
    self.bannerView.rootViewController = rootController;
    [view addSubview:self.bannerView];
    GADRequest *request = [GADRequest request];
 //   request.testDevices = @[ @"98da9ae7a75ee2bad7f76d6dadf238a5" ];
    [self.bannerView loadRequest:request];
    
  //  [view removeFromSuperview];
}

- (void)loadInterstitialForView:(UIView *)view forAdId:(NSString*)adId andRootController:(UIViewController*)rootController
{
    self.rootController = rootController;
    
    self.interstitialView = [[GADInterstitial alloc] init];
    self.interstitialView.adUnitID = adId;
    self.interstitialView.delegate = self;
    
    GADRequest *request = [GADRequest request];
    [self.interstitialView loadRequest:request];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [self.interstitialView presentFromRootViewController:self.rootController];
    NSLog(@"INTER OK!");
    
    if ([self.adView.delegate respondsToSelector:@selector(adShown:)])
        [self.adView.delegate adShown:self.adView];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"INTER FAIL!");
    
    if ([self.adView.delegate respondsToSelector:@selector(adLoadingFailed:)])
        [self.adView.delegate adLoadingFailed:self.adView];
}

@end
