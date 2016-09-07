//
//  QRService.m
//  QRCode
//
//  Created by LeeWong on 16/9/6.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "QRService.h"
#import "UIImage+QRCode.h"

@interface QRService () <AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//设置输出类型为Metadata，因为这种输出类型中可以设置扫描的类型，譬如二维码
//当启动摄像头开始捕获输入时，如果输入中包含二维码，就会产生输出
@property(nonatomic)AVCaptureMetadataOutput *output;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic) AVCaptureVideoPreviewLayer *previewLayer;


@property (nonatomic, copy) void (^scanResult)(NSString *aQRCode);

@end

@implementation QRService

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id shared;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
    });
    
    return shared;
}

- (void)createQRImage:(NSString *)aQRSourceString size:(CGFloat)imageSize completion:(void (^)(UIImage *result))aCompletion
{
    UIImage *img = [UIImage qrImageForString:aQRSourceString imageSize:imageSize withPointType:0 withPositionType:0 withColor:[UIColor clearColor]];
    aCompletion(img);
}

- (AVCaptureVideoPreviewLayer *)scanQRImage:(CGRect)windowSize viewSize:(CGRect)viewSize result:(void (^)(NSString *aQRCode))scanResult
{
    self.scanResult = scanResult;
    return [self creatCaptureDevice:windowSize viewSize:viewSize];
}


- (AVCaptureVideoPreviewLayer *)creatCaptureDevice:(CGRect)windowSize viewSize:(CGRect)viewSize{
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return nil;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    CGRect scanCrop=[self getScanCrop:windowSize readerViewBounds:viewSize];
    output.rectOfInterest = scanCrop;
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=viewSize;
//    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
    
    return layer;
}

#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}

#pragma mark 输出的代理
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:metadataObject.stringValue delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"再次扫描", nil];
        [alert show];
    }
}


#pragma mark - 识别图中二维码的功能
- (void)recognitionQRCodeFromImage:(UIImageView *)aImage completion:(void (^)(NSString *result,NSError *error))aCompletion
{
     CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:aImage.image.CGImage]];
    if (features.count >=1) {
        /**结果对象 */
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        aCompletion(scannedResult,nil);
        
    }
    else{
        
        NSError *error = [NSError errorWithDomain:@"QRCodeNotFound" code:-1000 userInfo:@{NSLocalizedDescriptionKey:@"QRCodeNotFound"}];
        aCompletion(nil,error);
    }

}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}


@end
