//
//  QRService.h
//  QRCode
//
//  Created by LeeWong on 16/9/6.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface QRService : NSObject

+ (instancetype)shared;

//生成二维码的方法、

- (void)createQRImage:(NSString *)aQRSourceString size:(CGFloat)imageSize completion:(void (^)(UIImage *result))aCompletion;

//扫描二维码的方法
- (AVCaptureVideoPreviewLayer *)scanQRImage:(CGRect)windowSize viewSize:(CGRect)viewSize result:(void (^)(NSString *aQRCode))scanResult;

//图片中识别二维码的方法
- (void)recognitionQRCodeFromImage:(UIImageView *)aImage completion:(void (^)(NSString *result,NSError *error))aCompletion;

@end
