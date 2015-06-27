//
//  TPCCaptureImageView.h
//
//  Created by 宋瑞旺 on 15/6/20.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPCCaptureImageView;

// 裁剪类型
typedef enum
{
    TPCCaptureTypeTrim,  // 裁剪
    TPCCaptureTypeStuff  // 填充
}TPCCaptureType;

@protocol TPCCaptureImageViewDelegate <NSObject>
@optional
// 传出截好的图片，由代理传入下一次要显示的图片
- (UIImage *)captureImageView:(TPCCaptureImageView *)captureImageView capturedImage:(UIImage *)image;

@end

@interface TPCCaptureImageView : UIImageView

/** 允许裁剪 */
@property (assign, nonatomic, getter=isEnableCapture) BOOL enbleCapture;

/** 图片裁剪代理 */
@property (weak, nonatomic) id <TPCCaptureImageViewDelegate> delegate;

/** 裁剪类型 */
@property (assign, nonatomic) TPCCaptureType captureType;

/** 遮罩透明度 */
@property (assign, nonatomic) CGFloat maskViewAlpha;

/** 遮罩颜色 */
@property (strong, nonatomic) UIColor *maskViewColor;
@end
