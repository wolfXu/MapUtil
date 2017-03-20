//
//  SQLiteManager.m
//  gongan
//
//  Created by xuzehan on 2017/3/1.
//  Copyright © 2017年 zhxu. All rights reserved.
//

#import "SQLiteManager.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabase.h"


@implementation SQLiteManager
static dispatch_once_t onceToken;
static SQLiteManager* sSharedInstance;

+(SQLiteManager *)sharedInstance{
    dispatch_once(&onceToken,^{
        sSharedInstance=[[SQLiteManager alloc]init];
    });
    return sSharedInstance;
}


-(instancetype)init{
    self=[super init];
    if(self){
        NSString* dbPath=[ROOTPATH stringByAppendingPathComponent:@"com_jintan.sqlite"];
        NSLog(@"数据库地址:%@",ROOTPATH);
        _dbQueue=[FMDatabaseQueue databaseQueueWithPath:dbPath];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            
        }];
    }
    return self;
}

-(void)createTable{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            if(![db tableExists:@"tbl_Map"]){
                [db executeUpdate:SQLCREATETABLE];
            }
        } @catch (NSException *exception) {
            *rollback=YES;
        }
    }];
}



-(void) saveOrUpdateMapData:(MapModel *)mData{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            //`latitude` , `longitude` ,`pinyin`,`description`,locationName`
            [db executeUpdate:@"REPLACE INTO tbl_Map(`latitude`,`longitude`,`pinyin`,`description`,`locationName`) VALUES (?,?,?,?,?)",mData.latitude,mData.longitude,mData.pinyin,mData.descriptions,mData.locationName];
        }
        @catch (NSException *exception) {
            NSLog(@"存储数据库出错:%@",exception);
            *rollback = YES;
        }
    }];
}

-(NSMutableArray*) getMapData{
    WEAKSELF
    __block NSMutableArray* apps;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs=[db executeQuery:GETMAPDATA];
        MapModel *mData;
        apps = [[NSMutableArray alloc] init];
        while([rs next]) {
            mData=[[MapModel alloc] init];
            [weakSelf constructMapData:mData resultSet:rs];
            [apps addObject:mData];
        }
        [rs close];
    }];
    return apps;
}


-(NSMutableArray*)getMapDataByQuery:(NSString*)queryString{
    WEAKSELF
    __block NSMutableArray* apps;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs=[db executeQuery:QUERYTABLE,[NSString stringWithFormat:@"%%%@%%",queryString],[NSString stringWithFormat:@"%%%@%%",queryString]];
        MapModel *mData;
        apps = [[NSMutableArray alloc] init];
        while([rs next]) {
            mData=[[MapModel alloc] init];
            [weakSelf constructMapData:mData resultSet:rs];
            [apps addObject:mData];
        }
        [rs close];
    }];
    return apps;
}


-(void)constructMapData:(MapModel*)data resultSet:(FMResultSet *)rs{
    data.longitude=[rs stringForColumn:@"longitude"];
    data.latitude=[rs stringForColumn:@"latitude"];
    data.locationName=[rs stringForColumn:@"locationName"];
    data.pinyin=[rs stringForColumn:@"pinyin"];
    data.descriptions=[rs stringForColumn:@"description"];
}
@end
