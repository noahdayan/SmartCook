//
//  SCMasterViewController.h
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCDetailViewController;

@interface SCMasterViewController : UITableViewController

@property (strong, nonatomic) SCDetailViewController *detailViewController;

@end
