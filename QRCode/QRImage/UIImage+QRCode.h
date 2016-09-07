//
//  UIImage+QRCode.h
//  QRCode
//
//  Created by LeeWong on 16/9/6.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    QRPointRect = 0,
    QRPointRound
}QRPointType;

typedef enum {
    QRPositionNormal = 0,
    QRPositionRound
}QRPositionType;

@interface UIImage (QRCode)

/**
 *  生成二维码图片的方法
 *
 *  @param string 二维码包含的内容
 *  @param size   图片的尺寸
 *  @param topimg 如果中间需要添加 头像可以传入此参数
 *
 *  @return 包含要生成内容的二维码图片
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size Topimg:(UIImage *)topimg;

/**
 *  生成二维码图片的方法
 *
 *  @param string       二维码包含的内容
 *  @param size         图片的尺寸
 *  @param pointType    点的类型（QRPointRect，QRPointRound）
 *  @param positionType 位置的类型 （QRPositionNormal，QRPositionRound）
 *  @param color        背景颜色
 *
 *  @return 包含要生成内容的二维码图片
 */
+(UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size withPointType:(QRPointType)pointType withPositionType:(QRPositionType)positionType withColor:(UIColor *)color;

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
+(UIImage*)qrImageForString:(NSString *)string imageSize:(CGFloat)size Topimg:(UIImage *)topimg withColor:(UIColor*)color;
@end
