//
//  ViewController.m
//  TPCCaptureImageView
//
//  Created by 宋瑞旺 on 15/6/20.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "ViewController.h"
#import "TPCCaptureImageView.h"

@interface ViewController () <TPCCaptureImageViewDelegate>
/** 图片 */
@property (weak, nonatomic) TPCCaptureImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TPCCaptureImageView *imageView = [[TPCCaptureImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"火影"];
    imageView.delegate = self;
    // 设置遮罩透明度
    imageView.maskViewAlpha = 0.5;
    // 设置遮罩颜色
    imageView.maskViewColor = [UIColor blackColor];
    // 设置裁剪类型
    imageView.captureType = TPCCaptureTypeStuff;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    [self setTestButton];
}

- (void)setTestButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 44);
    [button setTitle:@"切换方式"  forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor orangeColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addTarget:self action:@selector(switchCaptureType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)switchCaptureType:(UIButton *)btn
{
    static int type = 0;
    self.imageView.captureType = ++type % 2 ? TPCCaptureTypeTrim : TPCCaptureTypeStuff;
    self.imageView.image = [UIImage imageNamed:@"火影"];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark TPCCaptureImageViewDelegate
- (UIImage *)captureImageView:(TPCCaptureImageView *)captureImageView capturedImage:(UIImage *)image
{
    // image为裁剪好的图片，可以在此方法中保存图片
//    return [UIImage imageNamed:@"火影"];
    
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:@"/Users/songruiwang/Desktop/my.png" atomically:YES];
    
    // 返回要在imageView显示的图片
    return image;
}

@end
