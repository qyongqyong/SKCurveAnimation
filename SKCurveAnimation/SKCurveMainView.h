//
//  SKCurveMainView.h
//  SKCurveAnimation
//
//  Created by nachuan on 16/6/16.
//  Copyright © 2016年 SoKon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKCurveMainView : UIView

/** 点击回调 */
@property (nonatomic, copy) void(^centerBtnClickedBlock)(UIButton *);

@end
