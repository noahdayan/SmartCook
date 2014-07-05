//
//  SCRecipeInfo.m
//  SmartCook
//
//  Created by Noah Dayan on 12/26/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "SCRecipeInfo.h"

@implementation SCRecipeInfo

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
