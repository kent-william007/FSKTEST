//
//  YGGravityImageView.m
//  zhonggantest
//
//  Created by zhangkaifeng on 16/6/23.
//  Copyright © 2016年 张楷枫. All rights reserved.
//

#import "YGGravityImageView.h"
#import "YGGravity.h"

#define SPEED 50

@implementation YGGravityImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _myImageView = [[UIImageView alloc]init];
    [self addSubview:_myImageView];
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    _myImageView.image = image;
//    [_myImageView sizeToFit];
    _myImageView.frame = CGRectMake(0, 0, 50, 50);
    _myImageView.center = CGPointMake(kScreenW/2,kScreenH/2);
}

-(void)startAnimate
{
    float scrollSpeed = (_myImageView.frame.size.width - self.frame.size.width)/2/SPEED;
    
    //注意：此处时间间隔如果给0.01 iOS8下由于未知原因弹出键盘会导致cpu消耗大于100%
    [YGGravity sharedGravity].timeInterval = 0.02;
    [[YGGravity sharedGravity]startDeviceMotionUpdatesBlock:^(float x, float y, float z) {
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeDiscrete animations:^{
            
            if (_myImageView.frame.origin.x <=0 && _myImageView.frame.origin.x >= self.frame.size.width - _myImageView.frame.size.width)
            {
                float invertedYRotationRate = y * -1.0;
                
                float interpretedXOffset = _myImageView.frame.origin.x + invertedYRotationRate * (_myImageView.frame.size.width/[UIScreen mainScreen].bounds.size.width) * scrollSpeed + _myImageView.frame.size.width/2;
                
                _myImageView.center = CGPointMake(interpretedXOffset, _myImageView.center.y);
            }
            
            if (_myImageView.frame.origin.x >0)
            {
                _myImageView.frame = CGRectMake(0, _myImageView.frame.origin.y, _myImageView.frame.size.width, _myImageView.frame.size.height);
            }
            if (_myImageView.frame.origin.x < self.frame.size.width - _myImageView.frame.size.width)
            {
                _myImageView.frame = CGRectMake(self.frame.size.width - _myImageView.frame.size.width, _myImageView.frame.origin.y, _myImageView.frame.size.width, _myImageView.frame.size.height);
            }
        } completion:nil];
        
        
    }];
}

-(void)stopAnimate
{
    [[YGGravity sharedGravity] stop];
}

@end
