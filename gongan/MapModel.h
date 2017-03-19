//
//  MapModel.h
//  gongan
//
//  Created by xuzehan on 2017/3/9.
//  Copyright © 2017年 zhxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapModel : NSObject
@property(nonatomic,strong) NSString* latitude;
@property(nonatomic,strong) NSString* longitude;
@property(nonatomic,strong) NSString* locationName;
@property(nonatomic,strong) NSString* pinyin;
@property(nonatomic,strong) NSString* descriptions;

-(id) initWithDictionary:(NSDictionary*)jsonData;

@end
