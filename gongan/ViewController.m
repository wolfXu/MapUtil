#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "UIView+Toast.h"
#import "CustomAnnotationView.h"
#import "SearchViewController.h"
#import "MapModel.h"
#import "SQLiteManager.h"

@interface ViewController ()<MAMapViewDelegate,UIGestureRecognizerDelegate>
@property MAMapView* mapView;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
    [self setupGestures]; //自行在地图上添加一些手势
    [self loadData];
}


-(void)loadData{
    NSMutableArray* mData=[[SQLiteManager sharedInstance]getMapData];
    for (MapModel* model in mData) {
       CLLocationCoordinate2D temp=(CLLocationCoordinate2D){model.latitude.doubleValue,model.longitude.doubleValue};
        [self addAnnotationWithCooordinate:temp title:model.locationName subtitle:model.descriptions];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController  setToolbarHidden:NO animated:YES];
    self.title=@"首页";
}

/**
 如果开发者觉得地图内部手势的回调不够用，也可自行添加手势，但需要做一些额外的处理，才能保证地图内部的手势和自行添加的手势都能工作
 */
- (void)setupGestures
{
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.doubleTap.delegate = self;
    self.doubleTap.numberOfTapsRequired = 2;
    [self.mapView addGestureRecognizer:self.doubleTap];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.singleTap.delegate = self;
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    [self.mapView addGestureRecognizer:self.singleTap];
}

-(void)setupViews{
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    CGSize sizeNav=self.navigationController.navigationBar.bounds.size;
    CGSize screenSize=[UIScreen mainScreen].bounds.size;
    
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.mapType = MAMapTypeStandard;
    [self.view addSubview:self.mapView];
    [self initToolBar];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSearch)];
}

-(void)clickSearch{
    SearchViewController * controller = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [controller setHidesBottomBarWhenPushed:YES];
    WEAKSELF
    controller.localBlock=^(MapModel* model){
    CLLocationCoordinate2D temp=(CLLocationCoordinate2D){model.latitude.doubleValue,model.longitude.doubleValue};
        weakSelf.mapView.centerCoordinate=temp;
    };
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapTypeAction:(UISegmentedControl *)segmentedControl
{
    self.mapView.mapType = segmentedControl.selectedSegmentIndex;
}


- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    
    UISegmentedControl *mapTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:
                                                   [NSArray arrayWithObjects:
                                                    @"标准",
                                                    @"卫星",
                                                    @"标准黑夜",
                                                    @"导航",
                                                    @"公交",
                                                    nil]];
    mapTypeSegmentedControl.selectedSegmentIndex  = self.mapView.mapType;
    [mapTypeSegmentedControl addTarget:self action:@selector(mapTypeAction:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *mayTypeItem = [[UIBarButtonItem alloc] initWithCustomView:mapTypeSegmentedControl];
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, mayTypeItem, flexbleItem, nil];
}


#pragma mark - Map Delegate

/*!
 @brief 地图区域即将改变时会调用此接口
 @param mapview 地图View
 @param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
}

/*!
 @brief 地图区域改变完成后会调用此接口
 @param mapview 地图View
 @param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

/**
 *  地图将要发生移动时调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    
}


/**
 *  地图将要发生缩放时调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    
}


/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *customReuseIndetifier = @"customReuseIndetifier";
//        
//        MAPointAnnotation* view=annotation;
//        
//        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
//        
//        if (annotationView == nil)
//        {
//            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
//            // must set to NO, so we can show the custom callout view.
//            annotationView.canShowCallout = NO;
//            annotationView.draggable = YES;
//            annotationView.calloutOffset = CGPointMake(0, -5);
//        }
//        annotationView.annotation=annotation;
//        return annotationView;
//    }
//    
//    return nil;

    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor                     = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    
    return nil;
}


/*!
 @brief 当mapView新添加annotation views时调用此接口
 @param mapView 地图View
 @param views 新添加的annotation views
 */
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
}

/*!
 @brief 当选中一个annotation views时调用此接口
 @param mapView 地图View
 @param views 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    NSLog(@"点击大头针");
}

/*!
 @brief 当取消选中一个annotation views时调用此接口
 @param mapView 地图View
 @param views 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    
}

/*!
 @brief 标注view的accessory view(必须继承自UIControl)被点击时调用此接口
 @param mapView 地图View
 @param annotationView callout所属的标注view
 @param control 对应的control
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

/**
 *  标注view的calloutview整体点击时调用此接口
 *
 *  @param mapView 地图的view
 *  @param view calloutView所属的annotationView
 */
- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view {
    
}

/*!
 @brief 在地图View将要启动定位时调用此接口
 @param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView {
    
}

/*!
 @brief 在地图View停止定位后调用此接口
 @param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView {
    
}

/*!
 @brief 位置或者设备方向更新后调用此接口
 @param mapView 地图View
 @param userLocation 用户定位信息(包括位置与设备方向等数据)
 @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
}

/*!
 @brief 定位失败后调用此接口
 @param mapView 地图View
 @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
}

/*!
 @brief 当userTrackingMode改变时调用此接口
 @param mapView 地图View
 @param mode 改变后的mode
 @param animated 动画
 */
- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated {
    
}

/*!
 @brief 拖动annotation view时view的状态变化，ios3.2以后支持
 @param mapView 地图View
 @param view annotation view
 @param newState 新状态
 @param oldState 旧状态
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState {
    
}

/*!
 @brief 根据overlay生成对应的Renderer
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物Renderer
 */
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    return nil;
}

/*!
 @brief 当mapView新添加overlay renderer时调用此接口
 @param mapView 地图View
 @param renderers 新添加的overlay renderers
 */
- (void)mapView:(MAMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers {
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

/**
 返回NO，就是自行添加的手势不触发，返回YES就是触发
 比如，地图上有AnnotationView，单击了AnnotationView，既可以只相应地图内部的手势，也可以都响应，开发者可以根据需要，自行进行条件的组合来判断
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.singleTap && ([touch.view isKindOfClass:[UIControl class]] || [touch.view isKindOfClass:[MAAnnotationView class]]))
    {
        return NO;
    }
    
    if (gestureRecognizer == self.doubleTap && [touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    
    return YES;
}


#pragma mark 自行添加的手势的回调

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap
{
    NSLog(@"my single tap");
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap
{
    NSLog(@"my double tap");
}



#pragma mark - Map Delegate
/**
 *  地图移动结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    [self.view makeToast:[NSString stringWithFormat:@"did moved, newCenter = {%f, %f}", self.mapView.centerCoordinate.latitude,
                          self.mapView.centerCoordinate.longitude]];
}

/**
 *  地图缩放结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    [self.view makeToast:[NSString stringWithFormat:@"new zoomLevel = %.2f", self.mapView.zoomLevel]];
}

/**
 *  单击地图底图调用此接口
 *
 *  @param mapView    地图View
 *  @param coordinate 点击位置经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.view makeToast:[NSString stringWithFormat:@"coordinate =  {%f, %f}", coordinate.latitude, coordinate.longitude]];
}

/**
 *  长按地图底图调用此接口
 *
 *  @param mapView    地图View
 *  @param coordinate 长按位置经纬度
 */
- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    typeof(self) __weak weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入监控点信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *locationNameTextField = alertController.textFields.firstObject;
        UITextField *pinyinTextField=alertController.textFields[1];
        //获取第2个输入框；
        UITextField *descriptTextField = alertController.textFields.lastObject;
        
        [weakSelf addAnnotationWithCooordinate:coordinate title:locationNameTextField.text subtitle:descriptTextField.text];
        MapModel* model=[[MapModel alloc]init];
        model.latitude=[NSString stringWithFormat:@"%lf",coordinate.latitude];
        model.longitude=[NSString stringWithFormat:@"%lf",coordinate.longitude];
        model.locationName=locationNameTextField.text;
        model.pinyin=pinyinTextField.text;
        model.descriptions=descriptTextField.text;
        [[SQLiteManager sharedInstance]saveOrUpdateMapData:model];
    }]];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入地点名(大头针展示用)";
    }];
    //定义第二个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入拼音(有助于搜索更便捷)";
    }];
    //定义第三个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入详细介绍";
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}


-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title subtitle:(NSString*)subtitle
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title    = title;
    annotation.subtitle = subtitle;
    
    [self.mapView addAnnotation:annotation];
}
@end
