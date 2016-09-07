//
//  ViewController.m
//  QRCode
//
//  Created by LeeWong on 16/9/6.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ViewController.h"
#import "SCanQRCodeViewController.h"
#import "CreateQRCodeViewController.h"
#import "RecognizeImageQRCodeViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)createQRCode:(id)sender {
    CreateQRCodeViewController *scan = [[CreateQRCodeViewController alloc] init];
    [self.navigationController pushViewController:scan animated:YES];
}
- (IBAction)scanQRCode:(id)sender {
    SCanQRCodeViewController *scan = [[SCanQRCodeViewController alloc] init];
    [self.navigationController pushViewController:scan animated:YES];
}
- (IBAction)recognizeQRCode:(id)sender {
    
    RecognizeImageQRCodeViewController *scan = [[RecognizeImageQRCodeViewController alloc] init];
    [self.navigationController pushViewController:scan animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
