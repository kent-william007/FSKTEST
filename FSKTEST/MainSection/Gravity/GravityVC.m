//
//  GravityVC.m
//  FSKTEST
//
//  Created by kent on 2017/11/2.
//  Copyright © 2017年 kent. All rights reserved.
//

#import "GravityVC.h"
#import "YGGravityImageView.h"

@implementation GravityVC
- (void)viewDidLoad{
    [super viewDidLoad];
    
    YGGravityImageView *imageView = [[YGGravityImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,kScreenH)];
    imageView.image = [UIImage imageNamed:@"ball.png"];
    [self.view addSubview:imageView];
    [imageView startAnimate];
}
@end
