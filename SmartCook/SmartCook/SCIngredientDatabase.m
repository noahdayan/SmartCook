//
//  SCIngredientDatabase.m
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "SCIngredientDatabase.h"
#import "SCIngredientInfo.h"

@implementation SCIngredientDatabase

static SCIngredientDatabase *_database;

+ (SCIngredientDatabase *)database
{
    if(_database == nil)
    {
        _database = [[SCIngredientDatabase alloc] init];
    }
    
    return _database;
}

- (NSArray *)ingredientInfos
{
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT name, type FROM ingredients";
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *type = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            SCIngredientInfo *info = [[SCIngredientInfo alloc] initWithName:name Type:type];
            [infos addObject:info];
        }
        
        sqlite3_finalize(statement);
    }
    
    return infos;
}

- (NSArray *)ingredientInfosWithType:(NSString *)type
{
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"%@%@%@", @"SELECT name, type FROM ingredients WHERE type='", type, @"'"];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *type = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            SCIngredientInfo *info = [[SCIngredientInfo alloc] initWithName:name Type:type];
            [infos addObject:info];
        }
        
        sqlite3_finalize(statement);
    }
    
    return infos;
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
