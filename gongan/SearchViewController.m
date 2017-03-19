//
//  SearchViewController.m
//  gongan
//
//  Created by mac on 2017/2/16.
//  Copyright © 2017年 zhxu. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "SQLiteManager.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(strong,nonatomic)NSMutableArray* mData;
@end

@implementation SearchViewController

-(NSMutableArray *)mData
{
    if(!_mData){
        _mData=[[NSMutableArray alloc]init];
    }
    return _mData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    self.resultTableView.delegate=self;
    self.resultTableView.dataSource=self;
    self.resultLabel.text=@"";
    [self initSearchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initSearchView{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f,0.f, 200.f, 44.f)];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.backgroundColor=[UIColor whiteColor];
    [self.searchBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor] rect:CGRectMake(0, 0, SCREEN_WIDTH, 64.0f)]];
    self.searchBar.translucent=YES;
    self.searchBar.placeholder=@"请输入搜索词语";
    self.searchBar.delegate = self;
    self.searchBar.barStyle=UIBarStyleDefault;
    self.navigationItem.titleView = self.searchBar;
}

-(UIImage *) createImageWithColor:(UIColor *)color rect:(CGRect) rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.mData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"MapCell"];
    if(!cell){
       cell=(SearchTableViewCell*) [[[UINib nibWithNibName:@"SearchTableViewCell" bundle:[NSBundle mainBundle]]instantiateWithOwner:self options:nil] firstObject];
    }
    cell.model=self.mData[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.localBlock) {
        MapModel* model=self.mData[indexPath.row];
        self.localBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark searchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"搜索关键词:%@",searchBar.text);
    if(searchBar.text.length>0){
        [self hiddenKeyboard];
        self.mData=[[SQLiteManager sharedInstance]getMapDataByQuery:searchBar.text];
        self.resultLabel.text=[NSString stringWithFormat:@"共找到%ld条结果",self.mData.count];
        [self.resultTableView reloadData];
        
    }
}

- (void)hiddenKeyboard {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


@end
