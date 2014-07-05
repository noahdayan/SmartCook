//
//  SCRecipeDatabase.h
//  SmartCook
//
//  Created by Noah Dayan on 12/26/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SCRecipeDatabase : NSObject
{
    sqlite3 *_database;
}

+ (SCRecipeDatabase *)database;
- (NSArray *)recipeInfos;
- (NSArray *)recipeIngredients:(NSInteger)recipeID;
- (NSArray *)recipesWithIngredients:(NSArray *)ingredients;

@end
