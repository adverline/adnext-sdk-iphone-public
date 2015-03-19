//
//  HomeViewController.m
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 05/05/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewController.h"

@interface HomeViewController ()

@property (nonatomic, assign) BOOL isBanner;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)showInterstitialAd:(id)sender
{
    self.isBanner = FALSE;
    [self performSegueWithIdentifier:@"SegueAd" sender:nil];
}

- (IBAction)showBannerAd:(id)sender
{
    self.isBanner = TRUE;
    [self performSegueWithIdentifier:@"SegueAd" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueAd"])
    {
        ((ViewController*)segue.destinationViewController).isBanner = self.isBanner;
    }
}

@end
