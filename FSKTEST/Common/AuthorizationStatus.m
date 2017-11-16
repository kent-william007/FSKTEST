//
//  AuthorizationStatus.m
//  PingAnMember
//
//  Created by kent on 2017/3/2.
//  Copyright © 2017年 新越软件科技有限公司. All rights reserved.
//

#import "AuthorizationStatus.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation AuthorizationStatus
+ (BOOL)authorizationAVMediaTypeVideo{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"设备没有摄像头" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
     AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //首次使用 系统弹窗授权
    if (AVAuthorizationStatusNotDetermined == authStatus) {
        return YES;
    }else if(AVAuthorizationStatusAuthorized != authStatus){
        return  [self authorization:@"没有权限访问相机"];
    }
    return YES;
}
+ (BOOL)authorizationALAssetsLibrary
{
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    //首次使用 系统弹窗授权
    if (ALAuthorizationStatusNotDetermined == authStatus) {
        return YES;
    }else if (ALAuthorizationStatusAuthorized != authStatus) {
        return [self authorization:@"没有权限访问相册"];
    }
    return YES;
}
+ (BOOL)authorization:(NSString *)tipSmessage
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示:" message:tipSmessage preferredStyle:UIAlertControllerStyleAlert];
    [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * moveAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:moveAction];
    return NO;
}

#pragma mark -获取当前控制器
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
