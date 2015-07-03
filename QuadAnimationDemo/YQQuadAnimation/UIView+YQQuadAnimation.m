//
//  UIView+YQQuadAnimation.m
//  QuadAnimationDemo
//
//  Created by wangyaqing on 15/7/3.
//  Copyright (c) 2015年 billwang1990.github.io. All rights reserved.
//

#import "UIView+YQQuadAnimation.h"
#import <objc/runtime.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

static CGPoint destPoint;
static CGFloat offset = 150;

@implementation UIView (YQQuadAnimation)

- (void)animateToPoint:(CGPoint)point withCompleteBlk:(void (^)(void))blk
{
    if (self.mainLayer) {
        return;
    }
    
    destPoint = point;

    [self setupMainLayer];
    [self setCompleteBlk:blk];
    [self startAnimation];
}

#pragma mark private method
- (CGPoint)getPositionRelativeToWindow
{
    UIWindow *mainWin = [UIApplication sharedApplication].keyWindow;
    CGPoint p = [mainWin convertPoint:self.frame.origin fromView:nil];
    p.x += CGRectGetMidX(self.bounds);
    p.y += CGRectGetMidY(self.bounds);
    return p;
}

- (void)setupMainLayer
{
    if (self.mainLayer != nil) {
        return;
    }
    self.mainLayer = ({
        CALayer *tmpLayer = [CALayer layer];
        tmpLayer.contents = self.layer.contents;
        tmpLayer.contentsGravity = kCAGravityResizeAspectFill;
        tmpLayer.bounds = self.bounds;
        tmpLayer.masksToBounds = YES;
        tmpLayer.cornerRadius = self.layer.cornerRadius;
        tmpLayer.position = [self getPositionRelativeToWindow];

        tmpLayer;
    });
    
    UIWindow *mainWin = [UIApplication sharedApplication].keyWindow;
    [mainWin.layer addSublayer:self.mainLayer];
}

- (void)startAnimation
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.mainLayer.position];
    
    CGFloat y;
    
    BOOL isUp = [self getPositionRelativeToWindow].y > destPoint.y;
    
    if (isUp) {
        y = [self getPositionRelativeToWindow].y;
    }
    else
    {
        CGFloat tmp = [self getPositionRelativeToWindow].y - offset;
        
        y = tmp < 0 ? 0 : tmp;
    }
    
    CGFloat x = fabs([self getPositionRelativeToWindow].x - destPoint.x)/2;
    
    [path addQuadCurveToPoint:destPoint  controlPoint:CGPointMake(x, y)];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.3f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.3f;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 1.2f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 1.5f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [self.mainLayer addAnimation:groups forKey:@"group"];
}

#pragma mark delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.mainLayer removeFromSuperlayer];
    self.mainLayer  = nil;
    
    if ([self completeBlk]) {
        [self completeBlk]();
    }
}

#pragma mark setter & getter
- (CALayer *)mainLayer
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMainLayer:(CALayer *)mainLayer
{
    objc_setAssociatedObject(self, @selector(mainLayer), mainLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YQBlock)completeBlk
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCompleteBlk:(YQBlock)blk
{
    objc_setAssociatedObject(self, @selector(completeBlk), blk, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
