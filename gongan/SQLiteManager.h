//
//  SQLiteManager.h
//  gongan
//
//  Created by xuzehan on 2017/3/1.
//  Copyright © 2017年 zhxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "MapModel.h"

@interface SQLiteManager : NSObject
{
    FMDatabaseQueue *_dbQueue;
}

+(SQLiteManager *)sharedInstance;
-(void)createTable;
-(void) saveOrUpdateMapData:(MapModel *)mData;
-(NSMutableArray*)getMapData;
-(NSMutableArray*)getMapDataByQuery:(NSString*)queryString;
@end
