//
//  SCanQRCodeViewController.m
//  QRCode
//
//  Created by LeeWong on 16/9/6.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "SCanQRCodeViewController.h"
#import "QRImage/QRService.h"

#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height

static const CGFloat kBorderW = 100;
static const CGFloat kMargin = 30;

@interface SCanQRCodeViewController ()

@property (nonatomic, strong) NSString *codeResult;

@property (nonatomic, strong) UILabel *qrResult;

@property (nonatomic, strong) UIView *maskView;


@property (nonatomic, strong) UIView *scanWindow;
@property (nonatomic, strong) UIImageView *scanNetImageView;

@property (nonatomic, strong) UIButton *topLeftBtn;
@property (nonatomic, strong) UIButton *topRightBtn;
@property (nonatomic, strong) UIButton *bottomLeftBtn;
@property (nonatomic, strong) UIButton *bottomRightBtn;


@end

@implementation SCanQRCodeViewController

#pragma mark - Custom Method

#pragma mark 恢复动画
- (void)resumeAnimation
{
    CAAnimation *anim = [_scanNetImageView.layer animationForKey:@"translationAnimation"];
    if(anim){
        // 1. 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
        // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        // 3. 要把偏移时间清零
        [_scanNetImageView.layer setTimeOffset:0.0];
        // 4. 设置图层的开始动画时间
        [_scanNetImageView.layer setBeginTime:beginTime];
        
        [_scanNetImageView.layer setSpeed:1.0];
        
    }else{
        
        CGFloat scanNetImageViewH = 241;
        CGFloat scanWindowH = SCREEN_W - kMargin * 2;
        CGFloat scanNetImageViewW = _scanWindow.frame.size.width;
        
        _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowH);
        scanNetAnimation.duration = 1.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetImageView];
    }
    
    
    
}


#pragma mark - Load View

- (void)startScaning
{
    [self.view.layer insertSublayer:[[QRService shared] scanQRImage:_scanWindow.bounds viewSize:self.view.frame result:^(NSString *aQRCode) {
        NSLog(@"%@",aQRCode);
    }] atIndex:0];
}

- (void)customUI
{
    
    self.view.clipsToBounds=YES;
    //1.遮罩
    UIView *mask = [[UIView alloc] init];
    _maskView = mask;
    
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    mask.layer.borderWidth = kBorderW;
    
    mask.bounds = CGRectMake(0, 0, SCREEN_W + kBorderW + kMargin , SCREEN_W + kBorderW + kMargin);
    mask.center = CGPointMake(SCREEN_W * 0.5, SCREEN_H * 0.5);
    
    CGRect rect = mask.frame;
    rect.origin.y = 0;
    mask.frame = rect;
    
    [self.view addSubview:mask];
    
    CGFloat scanWindowH = SCREEN_W - kMargin * 2;
    CGFloat scanWindowW = SCREEN_W - kMargin * 2;
    _scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kBorderW, scanWindowW, scanWindowH)];
    _scanWindow.clipsToBounds = YES;
    [self.view addSubview:_scanWindow];
    
    _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
    CGFloat buttonWH = 18;
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindowW - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindowH - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.frame.origin.x, bottomLeft.frame.origin.y, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomRight];
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setBackgroundColor:[UIColor redColor]];
    back.layer.cornerRadius = 5.;
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    back.frame = CGRectMake(self.view.center.x-30, SCREEN_H - 100, 60, 30);
    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
 
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:@"EnterForeground" object:nil];

    [self customUI];
    [self startScaning];

}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=YES;
    [self resumeAnimation];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Lazy Load

- (UIView *)maskView
{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
        _maskView.layer.borderWidth = kBorderW;
        [self.view addSubview:_maskView];
    }
    return _maskView;
}

- (UIView *)scanWindow
{
    if (_scanWindow == nil) {
        _scanWindow = [[UIView alloc] init];
        _scanWindow.clipsToBounds = YES;
        [self.view addSubview:_scanWindow];
    }
    return _scanWindow;
}

- (UIImageView *)scanNetImageView
{
    if (_scanNetImageView == nil) {
        _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
        [self.scanWindow addSubview:_scanNetImageView];
    }
    return _scanNetImageView;
}

- (UIButton *)topLeftBtn
{
    if (_topLeftBtn == nil) {
        _topLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [_topLeftBtn setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
        [self.scanWindow addSubview:_topLeftBtn];
    }
    return _topLeftBtn;
}

- (UIButton *)topRightBtn
{
    if (_topRightBtn == nil) {
        _topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topRightBtn setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
        [self.scanWindow addSubview:_topRightBtn];
    }
    return _topRightBtn;
}

- (UIButton *)bottomLeftBtn
{
    if (_bottomLeftBtn == nil) {
        _bottomLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomLeftBtn setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
        [self.scanWindow addSubview:_bottomLeftBtn];
    }
    return _bottomLeftBtn;
}

- (UIButton *)bottomRightBtn
{
    if (_bottomRightBtn == nil) {
        _bottomRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomRightBtn setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
        [self.scanWindow addSubview:_bottomRightBtn];
    }
    return _bottomRightBtn;
}


@end
