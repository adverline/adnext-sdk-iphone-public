//
//  AdvAdRequest.h
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 28/04/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvAdRequest : NSMutableURLRequest

+ (instancetype)requestForBannerWithSection:(NSString*)section;
+ (instancetype)requestForInterstitialWithSection:(NSString*)section;

@end
