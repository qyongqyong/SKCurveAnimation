//
//  SKCurveMenuView.h
//  SKCurveAnimation
//
//  Created by nachuan on 16/6/16.
//  Copyright © 2016年 SoKon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKCurveItemView.h"
@interface SKCurveMenuView : UIView

/** 起始点 */
@property (nonatomic, assign) CGPoint startPoint;

/** 最近距离 */
@property (nonatomic, assign) NSUInteger nearDistance;

/** 最远距离 */
@property (nonatomic, assign) NSUInteger farDistance;

/** 结束距离 */
@property (nonatomic, assign) NSUInteger endDistance;

/** 展开的item数组 */
@property (nonatomic, strong) NSArray *curveItems;

/** 是否缩放 */
@property (nonatomic, assign) BOOL isScale;

@end
