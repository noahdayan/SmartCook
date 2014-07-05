//
//  SCIngredientInfo.m
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "SCIngredientInfo.h"

@implementation SCIngredientInfo

- (id)initWithName:(NSString *)name Type:(NSString *)type
{
    self = [super init];
    
    if(self)
    {
        self.name = name;
        self.type = type;
    }
    
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.type = nil;
}

@end
