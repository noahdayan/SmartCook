//
//  SCIngredientsDetailViewController.h
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <iAd/iAd.h>

@interface SCRecipesDetailViewController : PFQueryTableViewController <ADBannerViewDelegate>

@property (nonatomic, retain) NSArray *recipesIDs;

@end
