//
//  MBProgressHUD+Extesion.m
//  FSKTEST
//
//  Created by kent on 2017/10/27.
//  Copyright © 2017年 kent. All rights reserved.
//

#import "MBProgressHUD+Extesion.h"

@implementation MBProgressHUD (Extesion)

+ (void)showTips:(NSString *)tips{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [[UIApplication sharedApplication].delegate window];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = tips;
        hud.label.font = [UIFont systemFontOfSize:15];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:2];

    });
}

@end
