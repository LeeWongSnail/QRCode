//
//  RecognizeImageQRCodeViewController.m
//  QRCode
//
//  Created by LeeWong on 16/9/7.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "RecognizeImageQRCodeViewController.h"
#import "QRService.h"

#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height

@interface RecognizeImageQRCodeViewController ()

@end

@implementation RecognizeImageQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:@"1"];
    
    image.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.view addSubview:image];
    
    UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
    [image addGestureRecognizer:longPress];
    image.userInteractionEnabled = YES;
    
}

#pragma mark-> 长按识别二维码
-(void)dealLongPress:(UIGestureRecognizer*)gesture{
    
    if(gesture.state==UIGestureRecognizerStateBegan){
        
        UIImageView*tempImageView=(UIImageView*)gesture.view;
        if(tempImageView.image){
            [[QRService shared] recognitionQRCodeFromImage:tempImageView completion:^(NSString *result, NSError *error) {
              UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }];
        }else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:@"您还没有生成二维码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        
    }else if (gesture.state==UIGestureRecognizerStateEnded){
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
