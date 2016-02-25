//
//  AdvAdMobProvider.m
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 02/06/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//
@import GoogleMobileAds;
#import "AdvAdxProvider.h"


//#import "GADBannerView.h"
//#import "GADInterstitial.h"
#import "AdvAdView.h"

@interface AdvAdxProvider () <GADInterstitialDelegate>

@property (nonatomic, strong) DFPBannerView *bannerView;
@property (nonatomic, strong) DFPInterstitial *interstitialView;

@property (nonatomic, weak) UIViewController *rootController;

@end

@implementation AdvAdxProvider

- (void)loadAdForView:(UIView *)view forAdId:(NSString*)adId andRootController:(UIViewController*)rootController
{
    self.rootController = rootController;
    
    GADAdSize size = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? (kGADAdSizeFullBanner) : (kGADAdSizeBanner);
    CGPoint origin = CGPointMake(0.0,view.frame.size.height-CGSizeFromGADAdSize(size).height);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.bannerView = [[DFPBannerView alloc] initWithAdSize:size origin:origin];
    
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
    self.interstitialView = [[DFPInterstitial alloc] initWithAdUnitID:adId];
    self.interstitialView.delegate = self;
    DFPRequest *request = [DFPRequest request];
    //request.testDevices = @[ kGADSimulatorID ];
    [self.interstitialView loadRequest:request];
}

- (void)interstitialDidReceiveAd:(DFPInterstitial *)ad
{
    [self.interstitialView presentFromRootViewController:self.rootController];
    NSLog(@"INTER OK!");
    
    if ([self.adView.delegate respondsToSelector:@selector(adShown:)])
        [self.adView.delegate adShown:self.adView];
}

- (void)interstitial:(DFPInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"INTER FAIL!");
    
    if ([self.adView.delegate respondsToSelector:@selector(adLoadingFailed:)])
        [self.adView.delegate adLoadingFailed:self.adView];
}

@end
