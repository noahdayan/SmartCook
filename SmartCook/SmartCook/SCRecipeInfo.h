//
//  SCRecipeInfo.h
//  SmartCook
//
//  Created by Noah Dayan on 12/26/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCRecipeInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;

- (id)initWithName:(NSString *)name Type:(NSString *)type;

@end
