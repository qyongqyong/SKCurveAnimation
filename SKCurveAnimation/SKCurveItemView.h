//
//  SKCurveItmeView.h
//  SKCurveAnimation
//
//  Created by nachuan on 16/6/16.
//  Copyright © 2016年 SoKon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKCurveItemView : UIImageView

/** 起始点 */
@property (nonatomic, assign) CGPoint startPoint;

/** 结束点 */
@property (nonatomic, assign) CGPoint endPoint;

/** 最远点 */
@property (nonatomic, assign) CGPoint farPoint;

/** 最近点 */
@property (nonatomic, assign) CGPoint nearPoint;


@end
