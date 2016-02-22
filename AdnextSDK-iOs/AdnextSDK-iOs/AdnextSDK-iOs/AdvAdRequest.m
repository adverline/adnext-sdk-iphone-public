//
//  AdvAdRequest.m
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 28/04/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//

#import "AdvAdRequest.h"
#import "AdvReachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

//#define SERVEUR_URL (@"http://ads.adverline.com/adMobs.php")
#define SERVEUR_URL (@"http://adnext.fr/richmedia.adv?&isMobile=1&doincludes=1&nodv=1")

//http://adnext.fr/richmedia.adv?&nodv=1&id=102784&plc=15&uid=b0c4fc27d473de883aff3557eb741cde&w=1080&h=1776&network=4G

@implementation AdvAdRequest

+ (instancetype)requestForBannerWithSection:(NSString*)section
{
    AdvReachability* reach = [AdvReachability reachabilityWithHostname:@"www.google.com"];
    
    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    
    NSString *connectionStr = nil;
    
    if (reach.isReachableViaWiFi)
    {
        connectionStr = @"wifi";
    }
    else if (reach.isReachableViaWWAN)
    {
        CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
        NSLog(@"Current Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);
       
        BOOL isFast = [AdvAdRequest isFast:telephonyInfo.currentRadioAccessTechnology];
        
        if (isFast)
            connectionStr = @"3g";
        else
            connectionStr = @"edge";
    }
    else
    {
        return nil;
    }
    
    section = [NSString stringWithFormat:@"network_%@,%@", connectionStr, section];
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@&plc=15&section=%@", SERVEUR_URL, section];

    
    AdvAdRequest *adRequest = [AdvAdRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                           timeoutInterval:10];
    
    
    [adRequest setHTTPMethod:@"GET"];
    
    return adRequest;
}

+ (instancetype)requestForInterstitialWithSection:(NSString*)section
{
    AdvReachability* reach = [AdvReachability reachabilityWithHostname:@"www.google.com"];
    
    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    
    NSString *connectionStr = nil;
    
    if (reach.isReachableViaWiFi)
    {
        connectionStr = @"wifi";
    }
    else if (reach.isReachableViaWWAN)
    {
        CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
        NSLog(@"Current Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);
        
        BOOL isFast = [AdvAdRequest isFast:telephonyInfo.currentRadioAccessTechnology];
        
        if (isFast)
            connectionStr = @"3g";
        else
            connectionStr = @"edge";
    }
    else
    {
        return nil;
    }
    
    section = [NSString stringWithFormat:@"network_%@,%@", connectionStr, section];
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@&plc=14&section=%@", SERVEUR_URL, section];
    
    AdvAdRequest *adRequest = [AdvAdRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                           timeoutInterval:10];
    
    [adRequest setHTTPMethod:@"GET"];
    
    return adRequest;
}

+ (BOOL)isFast:(NSString*)radioAccessTechnology {
    if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
        return NO;
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]) {
        return NO;
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]) {
        return YES;
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]) {
        return YES;
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]) {
        return YES;
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        return YES;
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
        return YES;
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
        return YES;
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
        return YES;
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        return YES;
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
        return YES;
    }
    
    return YES;
}

@end
