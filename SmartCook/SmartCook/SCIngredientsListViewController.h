//
//  SCIngredientsListViewController.h
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCIngredientsDetailViewController;

@interface SCIngredientsListViewController : UITableViewController

@property (nonatomic, retain) NSArray *ingredientsInfos;
@property (nonatomic, retain) NSMutableArray *ingredientsIDs;

@property (nonatomic, retain) SCIngredientsDetailViewController *detailViewController;

@end
