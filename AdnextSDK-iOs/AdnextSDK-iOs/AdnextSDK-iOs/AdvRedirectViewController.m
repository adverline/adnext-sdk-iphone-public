//
//  AdvRedirectViewController.m
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 29/04/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//

#import "AdvRedirectViewController.h"

@interface AdvRedirectViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end


@implementation AdvRedirectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        CGFloat height = frame.size.width;
        frame.size.width = frame.size.height;
        frame.size.height = height;
    }
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]]];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webView];
    
    UIButton *closeButton = [self defaultCloseButton];
    [self.view addSubview:closeButton];
}

- (UIButton*)defaultCloseButton
{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(5, 25, 30, 30);
    [closeButton setImage:[UIImage imageNamed:@"AdvCloseButton.png"] forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(closeAd:) forControlEvents:UIControlEventTouchDown];
    
    return closeButton;
}

- (void)closeAd:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
