//
//  SKCurveMainView.m
//  SKCurveAnimation
//
//  Created by nachuan on 16/6/16.
//  Copyright © 2016年 SoKon. All rights reserved.
//

#import "SKCurveMainView.h"

/** 线宽 */
#define kLineWidth 4

/** 自身宽度 */
#define kWidth self.frame.size.width

/** 自身高度 */
#define kHeight self.frame.size.height

@interface SKCurveMainView ()

/** 边缘白色圆环 */
@property (nonatomic, strong) CAShapeLayer *outsideLayer;

/** 圆环进度条 */
@property (nonatomic, strong) CAShapeLayer *progressLayer;

/** 中间按钮 */
@property (nonatomic, strong) UIButton *centerBtn;

@end

@implementation SKCurveMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect = CGRectMake(kLineWidth / 2.0, kLineWidth / 2.0, kWidth - kLineWidth, kHeight - kLineWidth);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        [self setCenterBtn];
        [self setOutsideLayerWithPath:path];
        [self setProgressLayerWithPath:path];
        [self setGradientLayer];
        
    }
    return self;
}

/**
 *  初始化中间按钮
 */
- (void)setCenterBtn
{
    self.centerBtn = [[UIButton alloc] init];
    self.centerBtn.frame = CGRectMake(kLineWidth, kLineWidth, kWidth - kLineWidth * 2, kWidth - kLineWidth * 2);
    self.centerBtn.layer.cornerRadius = kWidth / 2 - kLineWidth;
    self.centerBtn.layer.masksToBounds = YES;
    self.centerBtn.adjustsImageWhenHighlighted = NO;
    [self.centerBtn setTitle:@"0%" forState:UIControlStateNormal];
    [self.centerBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self.centerBtn setBackgroundImage:[UIImage imageNamed:@"more_weibo"] forState:UIControlStateNormal];
    [self.centerBtn addTarget:self action:@selector(centerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.centerBtn];
        
}

/**初始化边缘白色圆环 */
- (void)setOutsideLayerWithPath:(UIBezierPath *)path
{
    self.outsideLayer = [CAShapeLayer layer];
    self.outsideLayer.path = path.CGPath;
    self.outsideLayer.lineWidth = kLineWidth;
    self.outsideLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.outsideLayer.fillColor = [UIColor clearColor].CGColor;
    self.outsideLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.outsideLayer];

}

/** 初始化圆环进度条 */
- (void)setProgressLayerWithPath:(UIBezierPath *)path
{
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.path = path.CGPath;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineWidth = kLineWidth;
    self.progressLayer.strokeEnd = 0;
    [self.layer addSublayer:self.progressLayer];
}

/** 设置渐变图层 */
- (void)setGradientLayer
{
    /** 设置左半部渐变图层 */
    CAGradientLayer *gradientLayerLeft = [CAGradientLayer layer];
    gradientLayerLeft.frame = CGRectMake(0, 0, kWidth / 2.0, kHeight);
    CGColorRef red = [UIColor redColor].CGColor;
    CGColorRef orange = [UIColor orangeColor].CGColor;
    CGColorRef yellow = [UIColor yellowColor].CGColor;
    CGColorRef green = [UIColor greenColor].CGColor;
    CGColorRef cyan = [UIColor cyanColor].CGColor;
    gradientLayerLeft.colors = @[(__bridge id)red, (__bridge id)orange, (__bridge id)yellow, (__bridge id)green, (__bridge id)cyan];
    gradientLayerLeft.locations = @[@0.2, @0.4, @0.6, @0.8, @1.0];
    gradientLayerLeft.startPoint = CGPointMake(0.5, 1);
    gradientLayerLeft.endPoint = CGPointMake(0.5, 0);
    
    /** 设置右半部渐变图层 */
    CAGradientLayer *gradientLayerRight = [CAGradientLayer layer];
    gradientLayerRight.frame = CGRectMake(kWidth / 2.0, 0, kWidth / 2.0, kHeight);
    CGColorRef blue = [UIColor blueColor].CGColor;
    CGColorRef purple = [UIColor purpleColor].CGColor;
    CGColorRef magenta = [UIColor magentaColor].CGColor;
    CGColorRef brown = [UIColor brownColor].CGColor;
    gradientLayerRight.colors = @[(__bridge id)blue, (__bridge id)purple, (__bridge id)magenta, (__bridge id)brown,(__bridge id)orange];
    gradientLayerRight.locations = @[@0.2, @0.4, @0.6, @0.8, @1.0];
    gradientLayerRight.startPoint = CGPointMake(0.5, 0);
    gradientLayerRight.endPoint = CGPointMake(0.5, 1);

    /** 设置整个渐变图层 */
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer addSublayer:gradientLayerLeft];
    [gradientLayerLeft addSublayer:gradientLayerRight];
    gradientLayer.mask = self.progressLayer;
    [self.layer addSublayer:gradientLayer];
    
}

/** 设置更新动画 */
- (void)updateProgressWithNumber:(NSInteger)number
{
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    self.progressLayer.strokeEnd = number / 100.0;
    [self.centerBtn setTitle:[NSString stringWithFormat:@"%@%%",@(number)] forState:UIControlStateNormal];
    [CATransaction commit];
}

/**
 *  中心按钮点击事件
 */
- (void)centerBtnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSInteger num = arc4random_uniform(100);
    [self updateProgressWithNumber:num];
    if (self.centerBtnClickedBlock) {
        self.centerBtnClickedBlock(sender);
    }
}











@end

