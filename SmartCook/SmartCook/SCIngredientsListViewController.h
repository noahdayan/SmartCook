//
//  SCIngredientsListViewController.h
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class SCRecipesDetailViewController;

@interface SCIngredientsListViewController : PFQueryTableViewController

@property (nonatomic, retain) NSString *ingredientsType;
@property (nonatomic, retain) NSMutableArray *ingredientsIDs;

@property (nonatomic, retain) SCRecipesDetailViewController *detailViewController;

@end
