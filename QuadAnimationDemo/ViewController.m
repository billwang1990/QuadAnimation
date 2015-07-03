//
//  ViewController.m
//  QuadAnimationDemo
//
//  Created by wangyaqing on 15/7/3.
//  Copyright (c) 2015年 billwang1990.github.io. All rights reserved.
//

#import "ViewController.h"
#import "UIView+YQQuadAnimation.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *testView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtn:(id)sender {
    
    [self.testView animateToPoint:CGPointMake(320, 430) withCompleteBlk:^{
        
    }];
}

@end
