//
//  SCIngredientDatabase.h
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SCIngredientDatabase : NSObject
{
    sqlite3 *_database;
}

+ (SCIngredientDatabase *)database;
- (NSArray *)ingredientInfos;
- (NSArray *)ingredientInfosWithType:(NSString *)type;

@end
