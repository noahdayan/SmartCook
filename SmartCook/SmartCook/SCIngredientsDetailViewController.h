//
//  SCIngredientsDetailViewController.h
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface SCIngredientsDetailViewController : UIViewController <ADBannerViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *ingredientCount;

@end
