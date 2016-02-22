//
//  ViewController.m
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 28/04/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//

#import "ViewController.h"
#import "AdvAdView.h"

@interface ViewController ()
{
    //banner
    AdvAdView *adViewBanner_;
    
    //interstitial
    AdvAdView *adViewInterstitial_;
}

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isBanner)
    {
        // Créez une vue à la taille standard en haut de l'écran.
        // Les constantes AdSize disponibles sont expliquées dans GADAdSize.h.
        adViewBanner_ = [[AdvAdView alloc] init];
        
        // Définissez l'ID du bloc d'annonces.
        adViewBanner_.adId = 0; // remplacez par votre ID_APPLICATION
        adViewBanner_.format = AdvAdFormatBanner;
        
        // Spécifiez le contrôleur UIViewController que l'exécution doit restaurer après avoir renvoyé
        // l'utilisateur à l'emplacement de destination de l'annonce et ajoutez-le à la hiérarchie de la vue.
        adViewBanner_.rootViewController = self;
        
        // Initiez une demande générique afin d'y charger une annonce.
        [adViewBanner_ loadRequest:[AdvAdRequest requestForBannerWithSection:@""] forCurrentView:self.view];
    }
    
    else
    {
        // Créez une vue à la taille standard en haut de l'écran.
        // Les constantes AdSize disponibles sont expliquées dans GADAdSize.h.
        adViewInterstitial_ = [[AdvAdView alloc] init];
        
        // Définissez l'ID du bloc d'annonces.
        adViewInterstitial_.adId = 0; // remplacez par votre ID_APPLICATION
        adViewInterstitial_.format = AdvAdFormatInterstitial;
        
        // Spécifiez le contrôleur UIViewController que l'exécution doit restaurer après avoir renvoyé
        // l'utilisateur à l'emplacement de destination de l'annonce et ajoutez-le à la hiérarchie de la vue.
        adViewInterstitial_.rootViewController = self;
        
        // Initiez une demande générique afin d'y charger une annonce.
        [adViewInterstitial_ loadRequest:[AdvAdRequest requestForInterstitialWithSection:@""] forCurrentView:self.view];
    }
}


@end
