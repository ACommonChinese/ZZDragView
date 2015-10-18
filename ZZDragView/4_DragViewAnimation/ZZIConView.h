//
//  ZZIConView.h
//  4_DragViewAnimation
//
//  Created by liuweizhen on 15/10/15.
//  Copyright (c) 2015年 愤怒的振振. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kZZIconViewLength 60

@class ZZIConView;
@protocol ZZIConViewDelegate <NSObject>

- (void)iconViewMove:(ZZIConView *)shakingView;
- (void)iconViewStopMove:(ZZIConView *)shakingView;
@end

@interface ZZIConView : UIControl

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, assign) id<ZZIConViewDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image text:(NSString *)text;

@end




