//
//  SKCurveMenuView.m
//  SKCurveAnimation
//
//  Created by nachuan on 16/6/16.
//  Copyright © 2016年 SoKon. All rights reserved.
//

#import "SKCurveMenuView.h"
#import "SKCurveMainView.h"
#import "SKCurveItemView.h"

#define kItemWidth item.bounds.size.width
#define kItemHeight item.bounds.size.height

#define kMainWidth _mainView.bounds.size.width
#define kMainHeight _mainView.bounds.size.height

#define animationDuration 0.5

@interface SKCurveMenuView ()

@property (nonatomic, strong) SKCurveMainView *mainView;

/** 是否展开 */
@property (nonatomic, assign) BOOL isExpand;


@property (nonatomic, copy) void(^buttonClickedBlock)(UIButton *);

@end

@implementation SKCurveMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mainView = [[SKCurveMainView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        __weak typeof (self)weakSelf = self;
        _mainView.centerBtnClickedBlock = ^(UIButton *sender){
            [weakSelf expand:sender.selected];
        };
        _mainView.center = self.center;
        _startPoint = self.center;
        _nearDistance = 30;
        _endDistance = 30;
        _farDistance = 60;
        [self addSubview:_mainView];
    }
    return self;
}

/**
 *  setCurveItems
 */
- (void)setCurveItems:(NSArray *)curveItems
{
    if (_curveItems != curveItems) {
        _curveItems = curveItems;
        for (UIView *view in self.subviews) {
            if (view.tag >= 1000) {
                [view removeFromSuperview];
            }
        }
        NSInteger count = curveItems.count;
        CGFloat angle = (2 * M_PI) / count;
        for (int i=0; i<count; i++) {
            SKCurveItemView *item = _curveItems[i];
            item.startPoint = self.startPoint;
            item.center = item.startPoint;
            item.transform = CGAffineTransformMakeScale(0.001, 0.001);
            item.tag = 1000 + i;
            
            CGFloat nearRadius = kItemWidth / 2.0 + self.nearDistance + kMainWidth / 2.0;
            CGFloat farRadius = kItemWidth / 2.0 + self.farDistance + kMainWidth / 2.0;
            CGFloat endRadius = kItemWidth / 2.0 + self.endDistance + kMainWidth / 2.0;
            item.nearPoint = [self getPointWithRadius:nearRadius withAngle:(i * angle)];
            item.farPoint = [self getPointWithRadius:farRadius withAngle:(i * angle)];
            item.endPoint = [self getPointWithRadius:endRadius withAngle:(i * angle)];
            [self addSubview:item];
        }
        [self bringSubviewToFront:_mainView];
    }
}

/**
 *  根据radius(半径)获取坐标点
 *
 *  @param radius 半径
 *  @param angle  角度
 *
 *  @return 坐标点
 */
- (CGPoint)getPointWithRadius:(CGFloat)radius withAngle:(CGFloat)angle
{
    return CGPointMake(self.startPoint.x + radius * sinf(angle), self.startPoint.y - radius * cosf(angle));
}


/**
 *  item展开的调用方法
 *
 *  @param isExpand 是否展开
 */
- (void)expand:(BOOL)isExpand
{
    _isExpand = isExpand;
    [self.curveItems enumerateObjectsUsingBlock:^(SKCurveItemView *item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_isScale) {
            if (isExpand) {
                item.transform = CGAffineTransformIdentity;
            }else{
                item.transform = CGAffineTransformMakeScale(0.001, 0.001);
            }
        }
        [self addRotateForCurveItem:item isShow:isExpand];
    }];
}

/**
 *  为curveItem添加是旋转动画
 */
- (void)addRotateForCurveItem:(SKCurveItemView *)item isShow:(BOOL)show
{
    if (show) {
        CABasicAnimation *scaleAnimation = nil;
        if (_isScale) {
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.duration = animationDuration;
            scaleAnimation.fromValue = @0.2;
            scaleAnimation.toValue = @1.0;
            scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        }
        
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = @[@(2 * M_PI), @0];
        rotateAnimation.duration = animationDuration;
        rotateAnimation.keyTimes = @[@1, @0];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = animationDuration;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
        CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        positionAnimation.path = path;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        CGPathRelease(path);
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        if (_isScale) {
            animationGroup.animations = @[scaleAnimation, rotateAnimation, positionAnimation];
        }else{
            animationGroup.animations = @[rotateAnimation, positionAnimation];
        }
        animationGroup.duration = animationDuration;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [item.layer addAnimation:animationGroup forKey:@"Expand"];
        item.center = item.endPoint;
    }else{
        CABasicAnimation *scaleAnimation = nil;
        if (_isScale) {
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.duration = animationDuration;
            scaleAnimation.fromValue = @1;
            scaleAnimation.toValue = @0.2;
            scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        }
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = @[@(2 * M_PI), @0];
        rotateAnimation.keyTimes = @[@1, @0];
        rotateAnimation.duration = animationDuration;
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = animationDuration;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
        CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        positionAnimation.path = path;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        CGPathRelease(path);
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        if (_isScale) {
            animationGroup.animations = @[scaleAnimation, rotateAnimation, positionAnimation];
        }else{
            animationGroup.animations = @[rotateAnimation, positionAnimation];
        }
        animationGroup.duration = animationDuration;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [item.layer addAnimation:animationGroup forKey:@"Close"];
        item.center = item.startPoint;
    }
}













































@end
