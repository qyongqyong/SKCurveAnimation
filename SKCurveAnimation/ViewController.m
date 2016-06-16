//
//  ViewController.m
//  SKCurveAnimation
//
//  Created by nachuan on 16/6/16.
//  Copyright © 2016年 SoKon. All rights reserved.
//

#import "ViewController.h"
#import "SKCurveMenuView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    SKCurveMenuView *view = [[SKCurveMenuView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    view.isScale = YES;
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<8; i++) {
        SKCurveItemView *item = [[SKCurveItemView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        item.image = [UIImage imageNamed:[NSString stringWithFormat:@"00%d",i + 1]];
        [items addObject:item];
    }
    view.curveItems = items;
    [self.view addSubview:view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
