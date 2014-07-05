//
//  SCRecipeDatabase.m
//  SmartCook
//
//  Created by Noah Dayan on 12/26/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "SCRecipeDatabase.h"
#import "SCRecipeInfo.h"
#import "SCIngredientInfo.h"

@implementation SCRecipeDatabase

static SCRecipeDatabase *_database;

+ (SCRecipeDatabase *)database
{
    if(_database == nil)
    {
        _database = [[SCRecipeDatabase alloc] init];
    }
    
    return _database;
}

- (NSArray *)recipeInfos
{
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT name, type FROM recipes";
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *type = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            SCRecipeInfo *info = [[SCRecipeInfo alloc] initWithName:name Type:type];
            [infos addObject:info];
        }
        
        sqlite3_finalize(statement);
    }
    
    return infos;
}

- (NSArray *)recipeIngredients:(NSInteger)recipeID
{
    NSMutableArray *ingredients = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"%@%i%@", @"SELECT name, type FROM ingredients WHERE id IN (SELECT ingredient_id FROM recipes_ingredients WHERE recipe_id=", recipeID, @")"];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *type = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            SCIngredientInfo *info = [[SCIngredientInfo alloc] initWithName:name Type:type];
            [ingredients addObject:info];
        }
        
        sqlite3_finalize(statement);
    }
    
    return ingredients;
}

- (NSArray *)recipesWithIngredients:(NSArray *)ingredients
{
    NSMutableArray *recipes = [[NSMutableArray alloc] init];
    
    //NSString *query = [NSString stringWithFormat:@"%@%@%@", @"SELECT name, type FROM recipes WHERE id IN (SELECT DISTINCT recipe_id FROM recipes_ingredients WHERE ingredient_id IN (", [ingredients componentsJoinedByString:@","], @"))"];
    NSString *query = [NSString stringWithFormat:@"%@%@%@", @"SELECT name, type FROM recipes WHERE id IN (SELECT DISTINCT recipe_id FROM recipes_ingredients WHERE ingredient_id IN (SELECT id FROM ingredients WHERE name IN ('", [ingredients componentsJoinedByString:@"','"], @"')))"];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *type = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            SCRecipeInfo *info = [[SCRecipeInfo alloc] initWithName:name Type:type];
            [recipes addObject:info];
        }
        
        sqlite3_finalize(statement);
    }
    
    return recipes;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        NSString *sqliteDB = [[NSBundle mainBundle] pathForResource:@"SmartCookDB" ofType:@"sqlite3"];
        
        if(sqlite3_open([sqliteDB UTF8String], &_database) != SQLITE_OK)
        {
            NSLog(@"Failed to open database!");
        }
    }
    
    return self;
}

- (void)dealloc
{
    sqlite3_close(_database);
}

@end
