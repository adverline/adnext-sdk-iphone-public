//
//  AdvAdView.h
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 28/04/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvAdRequest.h"


typedef enum
{
    AdvAdFormatUnknown,
    AdvAdFormatBanner,
    AdvAdFormatInterstitial
} AdvAdFormat;

typedef enum
{
    AdvAdAlignUnknown,
    AdvAdAlignTop,
    AdvAdAlignBottom
} AdvAdAlign;

typedef enum
{
    AdvAdAnimSlideUp,
    AdvAdAnimSlideDown,
    AdvAdAnimSlideLeft,
    AdvAdAnimSlideRight,
    AdvAdAnimFadeIn,
    AdvAdAnimFadeOut,
    AdvAdAnimFlipHorizontal,
    AdvAdAnimFlipVertical
} AdvAdAnim;



@class AdvAdView;


@protocol AdvAdDelegate <NSObject>

@optional
- (void)adLoadingFailed:(AdvAdView*)adView;
- (void)adLoaded:(AdvAdView*)adView;
- (void)adClicked:(AdvAdView*)adView;
- (void)adRefreshed:(AdvAdView*)adView;
- (void)adClosed:(AdvAdView*)adView;
- (void)adShown:(AdvAdView*)adView;

@end


@interface AdvAdView : UIView


@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, weak) id<AdvAdDelegate> delegate;

@property (nonatomic, assign) AdvAdFormat format;
@property (nonatomic, assign) AdvAdAlign align;

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, assign) NSInteger adId;

@property (nonatomic, assign) BOOL deactivateMisterBellPartner;
@property (nonatomic, assign) BOOL deactivateAdMobPartner;


- (void)loadRequest:(AdvAdRequest*)request forCurrentView:(UIView*)view;

@end
