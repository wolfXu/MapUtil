//
//  SearchViewController.h
//  gongan
//
//  Created by mac on 2017/2/16.
//  Copyright © 2017年 zhxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapModel.h"

typedef void(^LocatedDot)(MapModel* model);

@interface SearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong,nonatomic) UISearchBar* searchBar;
@property (strong,nonatomic)LocatedDot localBlock;
@end
