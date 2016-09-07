# QRCode
二维码扫描（基于系统提供的方法）

#### 1、目的
 现在越来越多的App添加了一个扫码的功能，方便而且很实用，但是目前对弈iOS来说有些比较知名的库（比如[ZXingObjC](https://github.com/TheLevelUp/ZXingObjC)）库都比较大，而实际上，在iOS 7.0之后系统在AVFoundation框架中就已经实现了对于二维码扫描和生成的的支持，我的方法主要是对系统的一些东西稍作封装（[QRCode](https://github.com/LeeWongSnail/QRCode)）
 
 
#### 2、生成二维码
目前见到的二维码一般是两种，中间有图片和没有图片的(通常是APP图标或者个人头像)或者是为二维码添加了背景颜色。这里我提供了三个方法，可以满足这几种需求。

```
/**
 *  生成二维码图片的方法
 *
 *  @param string 二维码包含的内容
 *  @param size   图片的尺寸
 *  @param topimg 如果中间需要添加 头像可以传入此参数
 *
 *  @return 包含要生成内容的二维码图片
 */
 
+ (UIImage *)qrImageForString:(NSString *)string 
	imageSize:(CGFloat)size Topimg:(UIImage *)topimg;

/**
 *  生成二维码图片的方法
 *
 *  @param string       二维码包含的内容
 *  @param size         图片的尺寸
 *  @param pointType    点的类型（QRPointRect，
 										QRPointRound）
 *  @param positionType 位置的类型 （QRPositionNormal，
 										QRPositionRound）
 *  @param color        背景颜色
 *
 *  @return 包含要生成内容的二维码图片
 */
+(UIImage *)qrImageForString:(NSString *)string 
				    imageSize:(CGFloat)size 
				withPointType:(QRPointType)pointType
			withPositionType:	
				 			(QRPositionType)positionType
				    withColor:(UIColor *)color;

/**
 *  生成二维码图片的方法
 *
 *  @param string 二维码包含的内容
 *  @param size    图片的尺寸
 *  @param topimg 如果中间需要添加 头像可以传入此参数
 *  @param color  背景颜色
 *
 *  @return 包含要生成内容的二维码图片
 */
 
+(UIImage*)qrImageForString:(NSString *)string 
				  imageSize:(CGFloat)size 
				     Topimg:(UIImage *)topimg 
				  withColor:(UIColor*)color;
				  
```

#### 3、二维码扫描
这里 需要重要注意的是 rectOfInterest属性的设置

```

//它的作用就是设置扫描范围
output.rectOfInterest = scanCrop;

这个CGRect参数和普通的Rect范围不太一样，它的四个值的范围都是0-1，表示比例。

rectOfInterest都是按照横屏来计算的 所以当竖屏的情况下 x轴和y轴要交换一下。

宽度和高度设置的情况也是类似。

```

具体的扫描结果通过遵守`AVCaptureMetadataOutputObjectsDelegate`协议并实现

`-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection`

代理方法就可以拿到

![扫描](https://i.niupic.com/images/2016/09/07/2ea1uC.gif)

#### 4、其他的使用场景

除了最常见的扫描识别二维码的方式之外 还有点击弹出框 选择识别图中二维码，或者 长按直接识别二维码的方式

```
/**
 *  识别图中的二维码
 *
 *  @param aImage      图片
 *  @param aCompletion 识别完成的回调
 */
- (void)recognitionQRCodeFromImage:(UIImageView *)aImage
		 completion:(void (^)(NSString *result,
		 					 NSError *error))aCompletion;

```
![长按识别](https://i.niupic.com/images/2016/09/07/f1hIfp.gif)


#### 5、总结
这样的话在我们日常使用中常见的几种对于二维码的操作，基本可以实现。希望这个demo对你有所帮助。
