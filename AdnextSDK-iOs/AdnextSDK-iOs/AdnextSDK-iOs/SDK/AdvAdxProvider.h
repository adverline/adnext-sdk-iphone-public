//
//  AdvAdxProvider.h
//  AdnextSDK-iOs
//
//  Created by Adverline on 24/02/2016.
//  Copyright © 2016 Adverline. All rights reserved.
//

#ifndef AdvAdxProvider_h
#define AdvAdxProvider_h

#import <Foundation/Foundation.h>
#import "AdvSDKProviderProtocol.h"

@interface AdvAdxProvider : NSObject<AdvSDKProviderProtocol>

@property (nonatomic, weak) AdvAdView *adView;

- (void)loadAdForView:(UIView *)view forAdId:(NSString*)adId andRootController:(UIViewController*)rootController;

@end

#endif /* AdvAdxProvider_h */
