//
//  ZZIConView.m
//  4_DragViewAnimation
//
//  Created by liuweizhen on 15/10/15.
//  Copyright (c) 2015年 愤怒的振振. All rights reserved.
//

#import "ZZIConView.h"

@interface ZZIConView ()

@property (nonatomic) CGPoint oldPoint;
@end

@implementation ZZIConView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kZZIconViewLength, kZZIconViewLength)];
}

- (instancetype)initWithImage:(UIImage *)image text:(NSString *)text {
    if (self = [self init]) {
        // imageView
        // self.imageView = [[UIImageView alloc] init];
        self.backgroundColor = [UIColor clearColor];
        CGFloat labelHeight = 20; // label高
        CGFloat space = 5.0; // 间隔
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kZZIconViewLength-20.0,kZZIconViewLength-labelHeight)];
        [self addSubview:_imageView];
        _imageView.image = image;
        
        // label
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame)+space, self.bounds.size.width, labelHeight-space)];
        _textLabel.font             = [UIFont systemFontOfSize:12.0];
        _textLabel.textAlignment    = NSTextAlignmentCenter;
        _textLabel.backgroundColor  = [UIColor clearColor];
        _textLabel.textColor        = [UIColor magentaColor];
        _textLabel.text = text;
        [self addSubview:_textLabel];
        
        [self addLongPress]; // 增加长按手势
    }
    return self;
}

- (void)addLongPress {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
}

// 长按方法
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    CGPoint point = [longPress locationInView:self.superview];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            // 识别出来长按 让它摇晃起来
            [self startShake];
            self.oldPoint = point;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            // 在拖动中 移动 并有可能和其他iconView对象交换位置
            CGFloat offsetX = point.x - self.oldPoint.x;
            CGFloat offsetY = point.y - self.oldPoint.y;
            CGPoint center = self.center;
            center.x += offsetX;
            center.y += offsetY;
            self.center = center;
            self.oldPoint = point;
            [self.delegate iconViewMove:self];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            // 手势结束 结束摇晃 重新排版 回到该回到的地方
            [self stopShake];
            [self.delegate iconViewStopMove:self]; // 让代理排版
        }
            break;
        case UIGestureRecognizerStateCancelled: {
            // 手势取消 结束摇动
        }
            break;
        case UIGestureRecognizerStateFailed: {
            // 结束摇动
        }
            break;
        default:
            break;
    }
}

// 开始晃动
- (void)startShake {
    // 放大
    self.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
    
    // 加阴影
    [self.layer setShadowColor:[UIColor grayColor].CGColor]; // 阴影颜色
    [self.layer setShadowRadius:10.0f]; // 阴影半径
    [self.layer setShadowOpacity:1.0f]; // 不透明度
    
    // 晃动
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"]; // 对transform操作
    shakeAnimation.duration     = 0.1; // 持续时间
    shakeAnimation.repeatCount  = HUGE_VAL; // MAXFLOAT;
    shakeAnimation.autoreverses = YES; // 一次动画完成后是否平滑的回到原始状态 才重新再开始动画
    shakeAnimation.fromValue    = [NSValue  valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -0.1, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue  valueWithCATransform3D:CATransform3DRotate(self.layer.transform, 0.1, 0, 0, 1)];
    [self.layer addAnimation:shakeAnimation forKey:@"shake"];   // 这个key和 - (void)stopShake 方法中的key要一致
}

// 结束晃动
- (void)stopShake {
    // 还原
    // self.layer.transform = CATransform3DIdentity;

    self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    [self.layer setShadowOpacity:0.0];
    
    // 移除晃动动画
    [self.layer removeAnimationForKey:@"shake"]; // 和addAnimation:的时候保持一致
}

@end





