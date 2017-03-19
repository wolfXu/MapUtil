//
//  MapModel.m
//  gongan
//
//  Created by xuzehan on 2017/3/9.
//  Copyright © 2017年 zhxu. All rights reserved.
//

#import "MapModel.h"


@implementation MapModel


-(id) initWithDictionary:(NSDictionary*)jsonData{
    self=[super init];
    if (self) {
        [jsonData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
        }];
    }
    return self;
}



@end
