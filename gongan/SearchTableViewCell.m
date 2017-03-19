//
//  SearchTableViewCell.m
//  gongan
//
//  Created by xuzehan on 2017/3/9.
//  Copyright © 2017年 zhxu. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MapModel *)model{
    _model=model;
    _descriptLabel.text=_model.descriptions;
    _locationLabel.text=_model.locationName;
}

@end
