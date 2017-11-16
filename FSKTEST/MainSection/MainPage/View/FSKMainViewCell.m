//
//  FSKMainViewCell.m
//  FSKTEST
//
//  Created by kent on 2017/10/26.
//  Copyright © 2017年 kent. All rights reserved.
//

#import "FSKMainViewCell.h"

@implementation FSKMainViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
//        self.backgroundColor = [UIColor whiteColor];
//        UIView * line1 = [[UIView alloc]init];
//        line1.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
//        [self addSubview:line1];
//        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.leading.trailing.equalTo(self);
//            make.height.equalTo(@1);
//        }];
//        
//        UIView * line2 = [[UIView alloc]init];
//        line2.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
//        [self addSubview:line2];
//        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.leading.trailing.equalTo(self);
//            make.height.equalTo(@1);
//        }];
    }
    return self;
}
- (UIImageView *)iconV{
    if (!_iconV) {
        _iconV = [[UIImageView alloc]init];
        [self addSubview:_iconV];
        [_iconV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _iconV;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        [self addSubview:_titleLab];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.backgroundColor = [UIColor lightGrayColor];
        _titleLab.textColor = [UIColor blackColor];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo(self);
            //make.top.equalTo(self.iconV.mas_bottom).offset(10);
        }];
    }
    return _titleLab;
}
@end
