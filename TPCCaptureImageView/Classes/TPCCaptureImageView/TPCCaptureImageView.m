//
//  TPCCaptureImageView.m
//  0150619图片上下文
//
//  Created by 宋瑞旺 on 15/6/20.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCCaptureImageView.h"


#define TPCMaskViewDefaultAlpha 0.5
@interface TPCCaptureImageView()

/** 手势 */
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

/** 起始位置 */
@property (assign, nonatomic) CGPoint startPoint;

/** 遮罩view */
@property (weak, nonatomic) UIView *captureMaskView;

@end

@implementation TPCCaptureImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    // 添加拖拽手势
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:_pan];
    
    // 默认开启用户交互
    self.userInteractionEnabled = YES;
}

#pragma mark 懒加载
- (UIView *)maskView
{
    if (_captureMaskView == nil) {
        UIView *captureMaskView = [[UIView alloc] init];
        captureMaskView.backgroundColor = [UIColor blackColor];
        captureMaskView.alpha = TPCMaskViewDefaultAlpha;
        [self addSubview:captureMaskView];
        self.captureMaskView = captureMaskView;
    }
    
    return _captureMaskView;
}

#pragma mark 手势回调函数
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint currentPoint = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startPoint = currentPoint;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        // 设置遮罩frame
        CGFloat maskW = currentPoint.x - self.startPoint.x;
        CGFloat maskH = currentPoint.y - self.startPoint.y;
        self.maskView.frame = CGRectMake(self.startPoint.x, self.startPoint.y, maskW, maskH);
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        // 获取裁剪后的图片
        UIImage *image = [self captureImageWithRect:self.maskView.frame];
        
        if ([self.delegate respondsToSelector:@selector(captureImageView:capturedImage:)]) {
            // 输出裁剪后的图片，并获取要显示的图片
            self.image = [self.delegate captureImageView:self capturedImage:image];
        }
    }
}

#pragma mark 获取裁剪图片
- (UIImage *)captureImageWithRect:(CGRect)rect
{
    UIBezierPath *path = nil;
    
    // maskView使不可见
    self.maskView.alpha = 0;
    
    if (self.captureType == TPCCaptureTypeTrim) {
        // 格式1.裁剪
        // 开启图片上下文，尺寸为imageView
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
        
        // 设置裁剪区域
        path = [UIBezierPath bezierPathWithRect:rect];
        [path addClip];
        
        // 获取上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        // 进行截屏
        [self.layer renderInContext:ctx];
        
    } else if (self.captureType == TPCCaptureTypeStuff) {
        // 格式2.填充
        // 开启图片上下文，尺寸为maskView
        UIGraphicsBeginImageContextWithOptions(self.maskView.bounds.size, NO, 0);
        
        // 将imageView的图片重新绘制进图片上下文中
        // 将图片的原点偏移，使选中区域刚好在上下文规定的大小中
        [self.image drawInRect:CGRectMake(-self.maskView.frame.origin.x, -self.maskView.frame.origin.y, self.bounds.size.width, self.bounds.size.height)];
    }
    
    // 获取上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    // maskView可见，并置为初始状态
    self.maskView.alpha = TPCMaskViewDefaultAlpha;
    self.maskView.frame = CGRectZero;
    
    return image;
}

- (void)setEnbleCapture:(BOOL)enbleCapture
{
    _enbleCapture = enbleCapture;
    
    // 设置手势使能喝用户交互使能
    self.pan.enabled = enbleCapture;
    self.userInteractionEnabled = enbleCapture;
}


- (void)setMaskViewAlpha:(CGFloat)maskViewAlpha
{
    _maskViewAlpha = maskViewAlpha;
    
    self.maskView.alpha = maskViewAlpha;
}

- (void)setMaskViewColor:(UIColor *)maskViewColor
{
    _maskViewColor = maskViewColor;
    
    self.maskView.backgroundColor = maskViewColor;
}
@end
