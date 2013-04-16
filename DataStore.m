//
//  DataStore.m
//  Funny
//
//  Created by 小 元 on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataStore.h"
#import "sqlite3.h"
#import "QSDataModel.h"

#define DB_NAME "funny_db.db"

@interface DataStore()
{
}

@end

sqlite3 *database = NULL;


@implementation DataStore

+ (int) opendb{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbName = [documentsDirectory stringByAppendingPathComponent:@DB_NAME];
    int result = sqlite3_open([dbName UTF8String], &database);
    if(result != SQLITE_OK){
        sqlite3_close(database);
        NSLog(@"Db can't open");
    }
    return result;
}

+ (void) closedb{
    sqlite3_close(database);
    database = NULL;
}


+ (void)saveData:(NSString *)data
{
    // open db
    int result = [DataStore opendb];
    if(result != SQLITE_OK)
    {
        return;
    }
    NSLog(@"Db opend");
    char* sql_craetetb = "create table if not exists tbFavorite ( id integer primary key autoincrement, content text )";
    char *errMessage;
    int ret = sqlite3_exec(database, sql_craetetb, NULL, NULL, &errMessage);
    NSLog(@"create table return : %d", ret);
    NSString *insertsql = [NSString stringWithFormat:@"insert into tbFavorite (content) values (\"%@\")",data];
    NSLog(@"insert sql:%@",insertsql);
    ret = sqlite3_exec(database, [insertsql UTF8String], NULL, NULL, &errMessage);
    NSLog(@"insert data return : %d", ret);
    [DataStore closedb];
}

+ (NSMutableArray *)readData
{
    int ret = [DataStore opendb];
    if(ret != SQLITE_OK){
        NSLog(@"can't open db");
        return nil;
    }
    NSLog(@"read db opened");
    int result ;
    sqlite3_stmt *statment = NULL;
    NSString *query = @"select content from tbFavorite";
    NSMutableArray *array = [[[NSMutableArray alloc ]init] autorelease];
    result = sqlite3_prepare_v2(database, [query UTF8String], -1, &statment, nil);
    if(result == SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
           // int row = sqlite3_column_int(statment,0);
            char * rowData = sqlite3_column_text(statment, 0);
            QSItem *item = [[[QSItem alloc] init]autorelease];
            item.Content = [NSString stringWithUTF8String:rowData];
            [array addObject:item];
        }
        sqlite3_finalize(statment);
    }else{
        NSLog(@"not prepare");
    }
    
    [DataStore closedb];
    return array;
}

@end
