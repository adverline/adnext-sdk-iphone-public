//
//  AdvAdView.m
//  AdnextSDK-iOs
//
//  Created by Xavier De Koninck on 28/04/2014.
//  Copyright (c) 2014 Adverline. All rights reserved.
//

#import "AdvAdView.h"
#import "AdvRedirectViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AdvSDKProviderProtocol.h"
#import "AdvAdMobProvider.h"
#import "AdvMisterBellProvider.h"
#import <AdSupport/ASIdentifierManager.h>


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


@interface AdvAdView ()<UIGestureRecognizerDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) NSDictionary *json;

@property (nonatomic, strong) UIWebView *wbDownloader;

@property (nonatomic, strong) AdvAdRequest *request;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *currentView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, assign) AdvAdAnim adAnimationStart;
@property (nonatomic, assign) CGFloat adAnimationDurationStart;

@property (nonatomic, assign) AdvAdAnim adAnimationEnd;
@property (nonatomic, assign) CGFloat adAnimationDurationEnd;

@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayer;

@property (nonatomic, strong) NSTimer *configCloseBtnTimer;
@property (nonatomic, strong) NSTimer *showCloseBtnTimer;
@property (nonatomic, strong) NSTimer *automaticClosingTimer;
@property (nonatomic, strong) NSTimer *flipTimer;

@property (nonatomic, strong) id<AdvSDKProviderProtocol> provider;

@property (nonatomic, strong) UIView *vTmp;
@property (nonatomic, strong) UIView *vTmp2;

@end


@implementation AdvAdView

- (id)init
{
    if (self = [super init])
    {
        self.data = [NSMutableData data];
        self.userInteractionEnabled = TRUE;
        self.idfa = self.identifierForAdvertising;
        NSLog(@"IDFA = %@", self.idfa);
        
        //        self.backgroundColor = [UIColor blueColor];
        
        // self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)loadRequest:(AdvAdRequest*)request forCurrentView:(UIView*)view
{
    self.currentView = view;
    self.request = request;
    
    CGRect superFrame = self.currentView.frame;
    
    CGFloat width = superFrame.size.width;
    CGFloat height = superFrame.size.height;
    
    //    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)
    //        && self.format == AdvAdFormatInterstitial)
    //    {
    //        CGFloat tmp = width;
    //        width = height;
    //        height = tmp;
    //    }
    
    self.request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&w=%.0f&h=%.0f&id=%ld&uid=%@", [self.request.URL absoluteString], width * [[UIScreen mainScreen] scale], height * [[UIScreen mainScreen] scale], (long)self.adId, self.appId]];
    
    NSLog(@"%@", [self.request.URL absoluteString]);
    
    self.wbDownloader = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.wbDownloader loadRequest:self.request];
    self.wbDownloader.delegate = self;
}


#pragma mark - NSURLConnection Delegate

- (void)showAd
{
    [self configAd];
    
    if ([[self.json[@"CONFIG"][@"TYPE"] uppercaseString] isEqualToString:@"HTML"])
        [self loadAdHtml];
    else if ([[self.json[@"CONFIG"][@"TYPE"] uppercaseString] isEqualToString:@"IMAGE"])
        [self loadAdImage];
    else if ([[self.json[@"CONFIG"][@"TYPE"] uppercaseString] isEqualToString:@"VIDEO"])
        [self loadAdVideo];
    
    
    [self configBgColor];
    
    [self configAnimation:&(_adAnimationStart) andDuration:&(_adAnimationDurationStart) forKey:@"START"];
    [self configAnimation:&(_adAnimationEnd) andDuration:&(_adAnimationDurationEnd) forKey:@"END"];
    
    //  [self configCloseButton];
    
    self.configCloseBtnTimer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(configCloseButton) userInfo:nil repeats:false];
    
    //    if (self.format != AdvAdFormatInterstitial || self.rootViewController.navigationController == nil)
    //        [self.currentView addSubview:self];
    //    else
    //    {
    //        [self.rootViewController.navigationController.view addSubview:self];
    //    }
    
    [self prepareAnimationStart];
}

#pragma mark - Configuration

- (void)configAd
{
    CGRect superFrame = self.currentView.frame;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat width = superFrame.size.width;
    CGFloat height = superFrame.size.height;
    
    //    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)
    //        && self.format == AdvAdFormatInterstitial)
    //    {
    //        CGFloat tmp = width;
    //        width = height;
    //        height = tmp;
    //    }
    
    if (self.format == AdvAdFormatBanner)
    {
        NSLog(@"BANNER");
        
        width = [self.json[@"CONFIG"][@"SIZE"][@"WIDTH"] floatValue];
        height = [self.json[@"CONFIG"][@"SIZE"][@"HEIGHT"] floatValue];
        
        self.align = AdvAdAlignUnknown;
        if ([[self.json[@"CUSTOMIZE"][@"VALIGN"] uppercaseString] isEqualToString:@"BOTTOM"])
            self.align = AdvAdAlignBottom;
        else
            self.align = AdvAdAlignTop;
        
        x = (superFrame.size.width - width) / 2;
        
        if (self.align == AdvAdAlignTop)
        {
            y = 0;
            self.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
        }
        else if (self.align == AdvAdAlignBottom)
        {
            y = superFrame.size.height - height;
            self.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
        }
    }
    
    else if (self.format == AdvAdFormatInterstitial)
    {
        //self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        if (self.rootViewController.navigationController != nil)
        {
            width = self.rootViewController.navigationController.view.frame.size.width;
            height = self.rootViewController.navigationController.view.frame.size.height;
            
            //            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
            //            {
            //                CGFloat widthTmp = width;
            //                width = height;
            //                height = widthTmp;
            //            }
        }
    }
    
    
    self.frame = CGRectMake(x, y, width, height);
}

- (void)configCloseButton
{
    if ([self.json[@"CUSTOMIZE"][@"BUTTON_CLOSE"][@"ACTIVE"] boolValue] == TRUE && self.format == AdvAdFormatInterstitial)
    {
        self.closeButton = [self defaultCloseButton];
        
        if (self.json[@"CUSTOMIZE"][@"BUTTON_CLOSE"][@"URL_BACKGROUND"] != nil
            && ![self.json[@"CUSTOMIZE"][@"BUTTON_CLOSE"][@"URL_BACKGROUND"] isEqualToString:@""])
        {
            NSData *imgBtnData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.json[@"CUSTOMIZE"][@"BUTTON_CLOSE"][@"URL_BACKGROUND"]]];
            
            [self.closeButton setImage:[UIImage imageWithData:imgBtnData] forState:UIControlStateNormal];
        }
        
        if (self.json[@"CUSTOMIZE"][@"BUTTON_CLOSE"][@"TIME_TO_ONSET"] != nil)
        {
            CGFloat timeBeforeOnset = [self.json[@"CUSTOMIZE"][@"BUTTON_CLOSE"][@"TIME_TO_ONSET"] floatValue];
            self.showCloseBtnTimer = [NSTimer scheduledTimerWithTimeInterval:timeBeforeOnset/1000 target:self selector:@selector(showCloseButton:) userInfo:nil repeats:FALSE];
        }
        else
            [self addSubview:self.closeButton];
        
        if (self.json[@"CUSTOMIZE"][@"TIMEOUT_CLOSE"] != nil && ![self.json[@"CUSTOMIZE"][@"TIMEOUT_CLOSE"] isKindOfClass:[NSString class]])
        {
            CGFloat timeBeforeClosing = [self.json[@"CUSTOMIZE"][@"TIMEOUT_CLOSE"] floatValue];
            self.automaticClosingTimer = [NSTimer scheduledTimerWithTimeInterval:timeBeforeClosing/1000 target:self selector:@selector(closeAd:) userInfo:nil repeats:FALSE];
        }
        
    }
}

- (void)configBgColor
{
    if (self.json[@"CUSTOMIZE"][@"BACKGROUND_COLOR"] != nil
        && ![self.json[@"CUSTOMIZE"][@"BACKGROUND_COLOR"] isEqualToString:@""])
    {
        NSString *colorStr = self.json[@"CUSTOMIZE"][@"BACKGROUND_COLOR"];
        
        NSArray *rgbStr = [colorStr componentsSeparatedByString:@","];
        if ([rgbStr count] == 3)
        {
            CGFloat red = [rgbStr[0] floatValue];
            CGFloat green = [rgbStr[1] floatValue];
            CGFloat blue = [rgbStr[2] floatValue];
            
            UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
            
            self.backgroundColor = color;
            self.contentView.backgroundColor = color;
            
            if ([self.contentView isKindOfClass:[UIWebView class]])
            {
                [((UIWebView*)self.contentView) stringByEvaluatingJavaScriptFromString:@"document.body.style.background = '#000000';"];
            }
        }
    }
}


- (void)configAnimation:(AdvAdAnim*)animation andDuration:(CGFloat*)duration forKey:(NSString*)key
{
    *duration = [self.json[@"CUSTOMIZE"][@"ANIMATION"][key][@"DELAY"] floatValue] / 1000;
    
    //TEST!!!!!
    // self.adAnimation = AdvAdAnimFadeIn;
    ///////////
    
    //    AdvAdAnimSlideUp,
    //    AdvAdAnimSlideDown,
    //    AdvAdAnimSlideLeft,
    //    AdvAdAnimSlideRight,
    //    AdvAdAnimFadeIn,
    //    AdvAdAnimFlipHorizontal,
    //    AdvAdAnimFlipVertical
    
    NSString *effect = self.json[@"CUSTOMIZE"][@"ANIMATION"][key][@"EFFECT"];
    
    if ([[effect uppercaseString] isEqualToString:@"SLIDE_UP"])
        *animation = AdvAdAnimSlideUp;
    else if ([[effect uppercaseString] isEqualToString:@"SLIDE_DOWN"])
        *animation = AdvAdAnimSlideDown;
    else if ([[effect uppercaseString] isEqualToString:@"SLIDE_LEFT"])
        *animation = AdvAdAnimSlideLeft;
    else if ([[effect uppercaseString] isEqualToString:@"SLIDE_RIGHT"])
        *animation = AdvAdAnimSlideRight;
    
    else if ([[effect uppercaseString] isEqualToString:@"FLIP_HORIZONTAL"])
        *animation = AdvAdAnimFlipHorizontal;
    else if ([[effect uppercaseString] isEqualToString:@"FLIP_VERTICAL"])
        *animation = AdvAdAnimFlipVertical;
    
    else if ([[effect uppercaseString] isEqualToString:@"FADE_IN"])
        *animation = AdvAdAnimFadeIn;
    else if ([[effect uppercaseString] isEqualToString:@"FADE_OUT"])
        *animation = AdvAdAnimFadeOut;
}


#pragma mark - Loading Ad Type

- (void)loadAdHtml
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
    
    webView.hidden = YES;
    webView.delegate = self;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.json[@"CONFIG"][@"CONTENT"]]]];
    //  [webView loadHTMLString:self.json[@"CONFIG"][@"CONTENT"] baseURL:nil];
    
    //webView.scrollView.scrollEnabled = FALSE;
    
    [self addSubview:webView];
    
    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
        && self.format == AdvAdFormatInterstitial)
    {
        CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
        transform = CGAffineTransformTranslate(transform, 128, 128);
        self.transform = transform;
    }
    
    self.contentView = webView;
}

- (void)loadAdImage
{
    NSURL *imageURL = [NSURL URLWithString:self.json[@"CONFIG"][@"CONTENT"]];
    //NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10.0];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (responseData != nil)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:responseData]];
        
        imgView.frame = self.bounds;
        
        [imgView setUserInteractionEnabled:FALSE];
        
        [self addSubview:imgView];
        
        self.contentView = imgView;
        
        if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
            && self.format == AdvAdFormatInterstitial)
        {
            CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
            transform = CGAffineTransformTranslate(transform, 128, 128);
            self.transform = transform;
            //      imgView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        }
    }
    //    CGRect frame = imgView.frame;
    //    frame.origin.x = 0;
    //    frame.origin.y = 0;
    //    imgView.frame = frame;
}


- (void)loadAdVideo
{
    NSURL *videoURL = [NSURL URLWithString:self.json[@"CONFIG"][@"CONTENT"]];
    
    NSLog(@"URL :: %@", videoURL);
    
    self.moviePlayer=[[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    
    self.moviePlayer.moviePlayer.controlStyle = MPMovieControlStyleNone;
    
    [self addSubview:self.moviePlayer.view];
    
    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
        && self.format == AdvAdFormatInterstitial)
    {
        CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
        transform = CGAffineTransformTranslate(transform, 128, 128);
        self.transform = transform;
    }
    
    self.contentView = self.moviePlayer.view;
    
    
    
    
    //    CGRect frame = self.moviePlayer.view.frame;
    //    frame.origin.x = 0;
    //    frame.origin.y = 0;
    //    self.moviePlayer.view.frame = frame;
    
    
    
    //   [self.rootViewController presentMoviePlayerViewControllerAnimated:moviePlayer];
    
    [self.moviePlayer.moviePlayer play];
    
    //    [[NSNotificationCenter defaultCenter]
    //     addObserver:self
    //     selector:@selector(movieFinishedCallback:)
    //     name:MPMoviePlayerPlaybackDidFinishNotification
    //     object:player];
    
    //
    //    player.shouldAutoplay = YES;
    
    //    [player.view setFrame:self.frame];
    
    //  player.fullscreen = YES;
    
    //
    
    //
    //    [player setFullscreen:YES animated:YES];
    
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
    //   [self removeFromSuperview];
    
    //    [self.closeButton setHidden:TRUE]
    
    if (self.moviePlayer != nil)
        [self.moviePlayer.moviePlayer stop];
    
    [self.automaticClosingTimer invalidate];
    [self.configCloseBtnTimer invalidate];
    [self.showCloseBtnTimer invalidate];
    [self.automaticClosingTimer invalidate];
    [self.flipTimer invalidate];
    
    [self prepareAnimationEnd];
}

- (void)showCloseButton:(id)sender
{
    [self addSubview:self.closeButton];
}

#pragma mark - Gestures Delegate

- (void)adPressed:(id)url
{
    if ([self.delegate respondsToSelector:@selector(adClicked:)])
        [self.delegate adClicked:self];
    
    AdvRedirectViewController *redirect = [[AdvRedirectViewController alloc] init];
    
    if ([url isKindOfClass:[NSString class]])
        redirect.url = url;
    else
        redirect.url = self.json[@"CONFIG"][@"REDIRECT"];
    
    redirect.url = [self updateMacro:redirect.url];
    
    NSLog(@"%@", [NSURL URLWithString:redirect.url]);
    
    [self closeAd:nil];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirect.url]];
    
    /*[self.rootViewController presentViewController:redirect animated:TRUE completion:^{
        
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirect.url]];
    }];*/
}


#pragma mark - WebView Delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.wbDownloader == webView)
    {
        if ([self.delegate respondsToSelector:@selector(adLoadingFailed:)])
            [self.delegate adLoadingFailed:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.wbDownloader == webView)
    {
        NSError *error;
        
        if ([self.delegate respondsToSelector:@selector(adLoaded:)])
            [self.delegate adLoaded:self];
        
        NSString *contents = [self.wbDownloader stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
        
        
        //        customize = pJson.getJSONObject("CUSTOMIZE");
        //        publisher_name = config.getString("SDK_CALLBACK").toString();
        //
        //        Si Config.SDK_CALLBACK == "" Alors // Comportement normal
        
        contents = [@"{" stringByAppendingString:contents];
        contents = [contents stringByAppendingString:@"}"];
        
        //   NSLog(@"%@", contents);
        
        self.json = [NSJSONSerialization
                     JSONObjectWithData:[[NSString stringWithFormat:@"%@", contents] dataUsingEncoding:NSUTF8StringEncoding]
                     options:kNilOptions
                     error:&error];
        
        
        NSString *publisherName = self.json[@"CONFIG"][@"SDK_CALLBACK"];
        
        if (publisherName != nil && ![publisherName isEqualToString:@""])
        {
            NSLog(@"NEW SDK : %@", contents);
            
            [self removeGestureRecognizer:self.tapGesture];
            
            
            /*
             if ([[self.json[@"CUSTOMIZE"][@"FORMAT"] uppercaseString] isEqualToString:@"BANNER"])
                self.format = AdvAdFormatBanner;
            else
                self.format = AdvAdFormatInterstitial;
            */
            //            JSONObject partner_selected = null, tmpPartner = null;
            
            NSDictionary *partnerSelected = nil;
            NSDictionary *tmpPartner = nil;
            
            NSArray *partners = self.json[@"CUSTOMIZE"][@"PARTNERS"];
            for (NSInteger i = 0; i < partners.count; i++)
            {
                tmpPartner = partners[i];
                if(publisherName != nil && ![publisherName isEqualToString:@""]){
                    if([[tmpPartner[@"NAME"] uppercaseString] isEqualToString:publisherName]){
                        partnerSelected = tmpPartner;
                        break;
                    }
                }
            }
            
            
            if(partnerSelected!=nil)
            {
                self.provider = nil;
                
                if([publisherName isEqualToString:@"ADMOB"]){
                    NSLog(@"ADMOB!!!");
                    
                    if (!self.deactivateAdMobPartner)
                        self.provider = [[AdvAdMobProvider alloc] init];
                }
                
                else if([publisherName isEqualToString:@"MISTERBELL"]) {
                    NSLog(@"MISTERBELL!!!");
                    
                    if (!self.deactivateMisterBellPartner)
                        self.provider = [[AdvMisterBellProvider alloc] init];
                }
                
                [self.provider setAdView:self];
                
                if (self.format == AdvAdFormatBanner)
                    [self.provider loadAdForView:self.currentView forAdId:partnerSelected[@"PUBLISHER_ID"][@"BANNER"] andRootController:self.rootViewController];
                else
                    [self.provider loadInterstitialForView:self.currentView forAdId:partnerSelected[@"PUBLISHER_ID"][@"INTERSTITIAL"] andRootController:self.rootViewController];
            }
            
        }
        else
        {
            NSLog(@"CONTENTS : %@", contents);
            
            //            self.json = [NSJSONSerialization
            //                         JSONObjectWithData:[[NSString stringWithFormat:@"{%@}", contents] dataUsingEncoding:NSUTF8StringEncoding]
            //                         options:kNilOptions
            //                         error:&error];
            //
            //            NSLog(@"JSON : %@", self.json);
            
            if (!self.json)
                return;
            
            if (self.json[@"CONFIG"][@"TRACKPAP"] != nil && ![self.json[@"CONFIG"][@"TRACKPAP"] isEqualToString:@""])
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.json[@"CONFIG"][@"TRACKPAP"]]];
                
                NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                
                [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    
                    // NSLog(@"TRACKYYY : %@", [[NSString alloc] initWithData:data
                    //                                             encoding:NSISOLatin1StringEncoding]);
                }];
                
            }
            
            self.format = AdvAdFormatUnknown;
            if ([[self.json[@"CUSTOMIZE"][@"FORMAT"] uppercaseString] isEqualToString:@"BANNER"])
                self.format = AdvAdFormatBanner;
            else
                self.format = AdvAdFormatInterstitial;
            
            [self showAd];
        }
    }
    else
    {
        NSString *padding = @"document.body.style.margin='0';document.body.style.padding = '0'";
        [webView stringByEvaluatingJavaScriptFromString:padding];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.wbDownloader != webView && self.contentView != webView)
    {
        NSLog(@"URL : %@", request.URL.absoluteString);
        
        if ([request.URL.absoluteString isEqualToString:@"about:blank"])
            return TRUE;
        
        [self adPressed:request.URL.absoluteString];
    }
    else if (self.wbDownloader == webView || self.contentView == webView)
        return TRUE;
    
    return FALSE;
}


#pragma mark - Animations

- (void)prepareAnimationStart
{
    if (self.format != AdvAdFormatInterstitial || self.rootViewController.navigationController == nil)
        [self.currentView addSubview:self];
    else
        [self.rootViewController.navigationController.view addSubview:self];
    
    if ([self.delegate respondsToSelector:@selector(adShown:)])
        [self.delegate adShown:self];
    
    if ([self.contentView isHidden])
        self.contentView.hidden = NO;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adPressed:)];
    [self.contentView addGestureRecognizer:self.tapGesture];
    [self.contentView setUserInteractionEnabled:TRUE];
    
    if (self.adAnimationStart == AdvAdAnimSlideUp
        || self.adAnimationStart == AdvAdAnimSlideDown
        || self.adAnimationStart == AdvAdAnimSlideLeft
        || self.adAnimationStart == AdvAdAnimSlideRight)
    {
        CGRect frame = self.frame;
        
        UIView *v = self.currentView;
        if (self.format == AdvAdFormatInterstitial
            && self.rootViewController.navigationController != nil)
            v = self.rootViewController.navigationController.view;
        
        if (self.adAnimationStart == AdvAdAnimSlideDown)
            frame.origin.y = -frame.size.height;
        else if (self.adAnimationStart == AdvAdAnimSlideUp)
            frame.origin.y = v.frame.size.height;
        else if (self.adAnimationStart == AdvAdAnimSlideLeft)
            frame.origin.x = v.frame.size.width;
        else if (self.adAnimationStart == AdvAdAnimSlideRight)
            frame.origin.x = -frame.size.width;
        self.frame = frame;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.adAnimationDurationStart];
        
        if (self.align == AdvAdAlignBottom)
            frame.origin.y = v.frame.size.height - frame.size.height;
        else
            frame.origin.y = 0;
        
        frame.origin.x = (v.frame.size.width - self.frame.size.width)/2;
        
        self.frame = frame;
        
        [UIView commitAnimations];
    }
    
    else if (self.adAnimationStart == AdvAdAnimFadeIn)
    {
        self.alpha = 0.f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.adAnimationDurationStart];
        
        self.alpha = 1.f;
        
        [UIView commitAnimations];
    }
    
    else if (self.adAnimationStart == AdvAdAnimFlipHorizontal)
    {
        CGRect frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        self.vTmp = [[UIView alloc] initWithFrame:frame];
        
        UIColor *color = self.currentView.backgroundColor;
        
        [self.vTmp setBackgroundColor:color];
        [self addSubview:self.vTmp];
        
        self.flipTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(flipHorizontal:) userInfo:nil repeats:false];
    }
    
    else if (self.adAnimationStart == AdvAdAnimFlipVertical)
    {
        CGRect frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        self.vTmp = [[UIView alloc] initWithFrame:frame];
        
        UIColor *color = self.currentView.backgroundColor;
        
        [self.vTmp setBackgroundColor:color];
        [self addSubview:self.vTmp];
        
        self.flipTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(flipVertical:) userInfo:nil repeats:false];
    }
}

- (void)flipHorizontal:(id)sender
{
    [UIView transitionFromView:(self.vTmp)
                        toView:(self.contentView)
                      duration: self.adAnimationDurationStart
                       options: UIViewAnimationOptionTransitionFlipFromTop
                    completion:^(BOOL finished) {
                        if (finished) {
                            
                        }
                    }
     ];
}

- (void)flipVertical:(id)sender
{
    [UIView transitionFromView:(self.vTmp)
                        toView:(self.contentView)
                      duration: self.adAnimationDurationStart
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        if (finished) {
                            
                        }
                    }
     ];
}

- (void)prepareAnimationEnd
{
    if ([self.delegate respondsToSelector:@selector(adClosed:)])
        [self.delegate adClosed:self];
    
    if (self.adAnimationEnd == AdvAdAnimSlideUp
        || self.adAnimationEnd == AdvAdAnimSlideDown
        || self.adAnimationEnd == AdvAdAnimSlideLeft
        || self.adAnimationEnd == AdvAdAnimSlideRight)
    {
        CGRect frame = self.frame;
        
        UIView *v = self.currentView;
        if (self.format == AdvAdFormatInterstitial
            && self.rootViewController.navigationController != nil)
            v = self.rootViewController.navigationController.view;
        
        //        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        //        {
        //            CGFloat widthTmp = frame.size.width;
        //            frame.size.width = frame.size.height;
        //            frame.size.height = widthTmp;
        //        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.adAnimationDurationEnd];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(closeView)];
        
        
        if (self.adAnimationEnd == AdvAdAnimSlideDown)
            frame.origin.y = v.frame.size.height;
        else if (self.adAnimationEnd == AdvAdAnimSlideUp)
            frame.origin.y = -frame.size.height;
        else if (self.adAnimationEnd == AdvAdAnimSlideLeft)
            frame.origin.x = -frame.size.width;
        else if (self.adAnimationEnd == AdvAdAnimSlideRight)
            frame.origin.x = v.frame.size.width;
        
        self.frame = frame;
        
        [UIView commitAnimations];
    }
    
    else if (self.adAnimationEnd == AdvAdAnimFadeOut)
    {
        self.alpha = 1.f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.adAnimationDurationEnd];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(closeView)];
        
        self.alpha = 0.f;
        
        [UIView commitAnimations];
    }
}

- (NSString*)nameOfPartnerForPartners:(NSArray*)partners
{
    NSInteger rand = arc4random() % 101;
    
    for (NSDictionary *partner in partners)
    {
        NSString *part = partner[@"PART_OF_VOICE"];
        
        NSArray *parts = [part componentsSeparatedByString:@","];
        
        if ([parts[0] integerValue] < rand && [parts[1] integerValue] > rand)
        {
            NSLog(@"PARTNER :: %@", partner[@"NAME"]);
            return partner[@"NAME"];
        }
    }
    return nil;
}

- (void)closeView
{
    NSLog(@"AD DEALLOC!");
    
    [self.contentView removeFromSuperview];
    [self removeFromSuperview];
}


- (NSString *)identifierForAdvertising
{
    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
    {
        NSUUID *IDFA = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        
        return [IDFA UUIDString];
    }
    
    return nil;
}

- (NSString *)updateMacro:(NSString*)str
{
    // TO DEBUG
    //str = [NSString stringWithFormat:@"%@%@", str, @"&idfa=__ADV_ADVERTISING_ID__"];
    NSString *new = [str stringByReplacingOccurrencesOfString: @"%%ADVERTISING_IDENTIFIER_PLAIN%%" withString:self.idfa];
    new = [new stringByReplacingOccurrencesOfString: @"__ADV_ADVERTISING_ID__" withString:self.idfa];
    return new;
}

@end
