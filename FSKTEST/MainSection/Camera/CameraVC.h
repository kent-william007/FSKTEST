//
//  CameraVC.h
//  FSKTEST
//
//  Created by kent on 2017/10/28.
//  Copyright © 2017年 kent. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface CameraVC : UIViewController
@property(nonatomic,assign)UIImagePickerControllerSourceType sourcType;
@property(nonatomic,assign)UIImagePickerControllerCameraDevice cameraType;
@property(nonatomic,assign)UIImagePickerControllerCameraCaptureMode captureMode;
@end
