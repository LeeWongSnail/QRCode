//
//  CreateQRCodeViewController.m
//  QRCode
//
//  Created by LeeWong on 16/9/6.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "CreateQRCodeViewController.h"
#import "QRImage/QRService.h"

#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height

@interface CreateQRCodeViewController ()

@end

@implementation CreateQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake(50, 100, 300, 300);
    [[QRService shared] createQRImage:@"http//:www.baidu.com" size:200 completion:^(UIImage *result) {
        imageV.image = result;
    }];
    [self.view addSubview:imageV];
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=YES;
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=NO;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
