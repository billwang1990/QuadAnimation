//
//  UIView+YQQuadAnimation.h
//  QuadAnimationDemo
//
//  Created by wangyaqing on 15/7/3.
//  Copyright (c) 2015年 billwang1990.github.io. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YQBlock)(void);

@interface UIView (YQQuadAnimation)


/**
 *  quadratic animation
 *
 *  @param point
 *  @param blk
 */
- (void)animateToPoint:(CGPoint)point withCompleteBlk:(void(^)(void))blk;

@property (nonatomic, strong) CALayer *mainLayer;

@end
