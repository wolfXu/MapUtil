//
//  SearchTableViewCell.h
//  gongan
//
//  Created by xuzehan on 2017/3/9.
//  Copyright © 2017年 zhxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapModel.h"

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptLabel;
@property (strong,nonatomic)MapModel *model;
@end
