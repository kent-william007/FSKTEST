//
//  AuthorizationStatus.h
//  PingAnMember
//
//  Created by kent on 2017/3/2.
//  Copyright © 2017年 新越软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizationStatus : NSObject
/**
 *  判断是有使用相机权限 无则返回NO
 */
+ (BOOL)authorizationAVMediaTypeVideo;
/**
 *  判断是有使用相册权限 无则返回NO
 */
+ (BOOL)authorizationALAssetsLibrary;
@end
