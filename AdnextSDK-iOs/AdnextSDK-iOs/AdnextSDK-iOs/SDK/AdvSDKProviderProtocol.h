//
//  AdvSDKProviderProtocol.h
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 02/06/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdvAdView;

@protocol AdvSDKProviderProtocol <NSObject>

@required

@property (nonatomic, weak) AdvAdView *adView;

- (void)loadAdForView:(UIView *)view forAdId:(NSString*)adId andRootController:(UIViewController*)rootController;

- (void)loadInterstitialForView:(UIView *)view forAdId:(NSString*)adId andRootController:(UIViewController*)rootController;

@end
