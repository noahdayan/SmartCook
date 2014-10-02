//
//  SCIngredientsDetailViewController.m
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "SCIngredientsDetailViewController.h"

@interface SCIngredientsDetailViewController ()

@end

@implementation SCIngredientsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Ingredient Detail";
    self.ingredientCount.text = @"0 Ingredients";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.detailDescriptionLabel = nil;
}

#pragma mark - ADViewDelegate

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

@end
