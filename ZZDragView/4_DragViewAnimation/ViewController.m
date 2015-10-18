//
//  ViewController.m
//  4_DragViewAnimation
//
//  Created by liuweizhen on 15/10/15.
//  Copyright (c) 2015年 愤怒的振振. All rights reserved.
//

#import "ViewController.h"
#import "ZZIConView.h"
#define NUM_OF_COLUMN 4 // 4列图标

@interface ViewController () <ZZIConViewDelegate>

@property (nonatomic) NSMutableArray *iconViewArray; // 存放图标对象iconView
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.iconViewArray = [NSMutableArray array];
    
    // 创建12个图标视图 ZZIConView
    for (int i = 0; i <= 11; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i]];
        NSString *text = [NSString stringWithFormat:@"index: %d", i];
        ZZIConView *iconView = [[ZZIConView alloc] initWithImage:image text:text]; // iconView大小固定了 [0, 0, kZZIConvViewLength, kZZIConViewLength]
        iconView.delegate = self;
        [iconView addTarget:self action:@selector(iconViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:iconView];
        [self.iconViewArray addObject:iconView];
    }
    
    // 排版
    [self layoutIconViews];
}

- (void)iconViewClick:(ZZIConView *)iconView {
    NSLog(@"%@", iconView.textLabel.text);
}

- (void)layoutIconViews {
    /**
     拖动小视图时，如果这个小视图和其他小视图相交了，要重新排版
     */
    [self layoutIconViewsWithShakingIconView:nil];
}

// 程序刚开始，或手指头拖动小视图时都需要排版，而当拖动一个小视图和其他小视图有交集时，要知道哪个小视图在摇动
- (void)layoutIconViewsWithShakingIconView:(ZZIConView *)shakingIconView {
    float xMargin = 30; // 两侧（距边界）水平间距
    float yMargin = 30; // （距边界）顶部间距
    
    // 图标（水平方向）之间的间距
    float xPadding = (self.view.frame.size.width - 2*xMargin - NUM_OF_COLUMN*kZZIconViewLength)/(NUM_OF_COLUMN-1);
    float yPadding = 50;
    
    for (int i = 0; i < self.iconViewArray.count; i++) {
        ZZIConView *iconView = [self.iconViewArray objectAtIndex:i];
        if (shakingIconView && iconView == shakingIconView) {
            continue; // 不对晃动的iconView本身排版 （晃动的iconView正在用户的拖动中）
        }
        float originX = xMargin + (i%NUM_OF_COLUMN)*(kZZIconViewLength+xPadding);
        float originY = yMargin + (i/NUM_OF_COLUMN)*(kZZIconViewLength+yPadding);
        CGRect frame = iconView.frame;
        frame.origin.x = originX;
        frame.origin.y = originY;
        iconView.frame = frame;
    }
}

// 当shakingIconView不等于nil时，说明在移动过程中
// 如果shakingIconView传过来是nil, 说明手指头已经不处于移动状态了
- (void)layoutIconViewsWithShakingIconView:(ZZIConView *)shakingIconView animation:(BOOL)animation {
    if (shakingIconView) { // 移动过程中
        if (animation) {
            [UIView animateWithDuration:0.4 animations:^{
                [self layoutIconViewsWithShakingIconView:shakingIconView]; // 排版加入动画中
            } completion:nil];
        } else {
            [self layoutIconViewsWithShakingIconView:shakingIconView];
        }
    } else { // 不处于移动状态
        if (animation) {
            [UIView animateWithDuration:0.4 animations:^{
                [self layoutIconViewsWithShakingIconView:nil];
            } completion:nil];
        } else {
            [self layoutIconViewsWithShakingIconView:nil];
        }
    }
}


#pragma mark - <ZZIConViewDelegate>
// 移动
- (void)iconViewMove:(ZZIConView *)shakingView {
    if (shakingView) {
        // 查看晃动的视图和其他视图有没有交集，如果相交的话，交换这两个视图的位置，并且排版
        // 实现方法：判断shakingView矩形和数组_iconViewArray中的每一个对象frame是否有重叠（有交集），改变这两个对象在数组_iconViewArray中的位置，排版
        for (int i = 0; i < self.iconViewArray.count; i++) {
            ZZIConView *iconView = (ZZIConView*)[self.iconViewArray objectAtIndex:i];
            if (iconView != shakingView) {
                // 判断是否重叠s
                if (CGRectIntersectsRect(shakingView.frame, iconView.frame)) {
                    // 交换这两个对象在数组self.iconViewArray中的位置
                    [self.iconViewArray exchangeObjectAtIndex:[self.iconViewArray indexOfObject:shakingView] withObjectAtIndex:[self.iconViewArray indexOfObject:iconView]];
                    
                    // 排版（因为排版根据数组内容来排版的）
                    [self layoutIconViewsWithShakingIconView:shakingView animation:YES];
                }
            }
        }
    }
}

// 停止
- (void)iconViewStopMove:(ZZIConView *)shakingView {
    [self layoutIconViewsWithShakingIconView:nil animation:YES];
}

@end





