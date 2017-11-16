//
//  CameraVC.m
//  FSKTEST
//
//  Created by kent on 2017/10/28.
//  Copyright © 2017年 kent. All rights reserved.
//

#import "CameraVC.h"
#import "AuthorizationStatus.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define CAMERA_TRANSFORM  1.24299
@interface CameraVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController * pickerController;

@property (nonatomic, strong) AVPlayer * player;

@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, strong) UIImageView * showImageView;
@property (nonatomic, strong) UILabel * showTitle;

@end

@implementation CameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    if (self.captureMode == UIImagePickerControllerCameraCaptureModePhoto){
        _isVideo = NO;
    }else{
        _isVideo = YES;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self presentViewController:self.pickerController animated:YES completion:nil];
        
        if (_isVideo) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.pickerController startVideoCapture];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.pickerController stopVideoCapture];
                });
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.pickerController takePicture];
            });
        }
    });
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) { //如果是拍照
        UIImage * image;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (_pickerController.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        
        [self.showImageView setImage:image];
        [self.view addSubview:self.showImageView];
        self.showTitle.text = @"拍摄的图片";
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
    } else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){ //如果是录制视频
        NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString * urlStr = [url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"放弃");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 点击方法
- (void)clickButton:(UIButton *)sender{
    
    [self presentViewController:self.pickerController animated:YES completion:nil];
}

#pragma mark - 自定义方法
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    } else {
        NSLog(@"视频保存成功");
        //录制完后自动播放
        NSURL * url = [NSURL fileURLWithPath:videoPath];
        _player = [AVPlayer playerWithURL:url];
        AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame = self.showImageView.bounds;
        [self.view.layer addSublayer:playerLayer];
        [_player play];
        self.showTitle.text = @"录制的视频";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });

    }
}



- (UIImagePickerController *)pickerController{
    if (![AuthorizationStatus  authorizationAVMediaTypeVideo]) return nil;
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc] init];
        //设置_pickerController的来源，这里设置为摄像头。
        /*
         UIImagePickerControllerSourceTypePhotoLibrary：照片库
         ，默认值
         UIImagePickerControllerSourceTypeCamera：摄像头
         UIImagePickerControllerSourceTypeSavedPhotosAlbum：相
         */
        //_pickerController.sourceType = self.sourcType;
        //设置摄像头类型
        /*
         UIImagePickerControllerCameraDeviceRear,//后置摄像头
         UIImagePickerControllerCameraDeviceFront //前置摄像头
         */

//        _pickerController.cameraDevice = self.cameraType;
        
//        if (_isVideo) {//设置媒体类型为视频，默认为kUTTypeImage；
//            _pickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
//            _pickerController.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
//            _pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
//            
//        }else{//设置摄像头捕获模式为 UIImagePickerControllerCameraCaptureModePhoto（默认就是）
//            
//            _pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//        }
        _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

        if (_isVideo) {
            _pickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
            //_pickerController.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
            _pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;

        }else{
            _pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
        
        CGSize screenBounds = [UIScreen mainScreen].bounds.size;
        CGFloat cameraAspectRatio = 4.0f/3.0f;
        CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
        CGFloat scale = screenBounds.height / camViewHeight;
        _pickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        _pickerController.cameraViewTransform = CGAffineTransformScale(_pickerController.cameraViewTransform, scale, scale);
        
        _pickerController.showsCameraControls = NO;
        _pickerController.allowsEditing = NO; // 允许编辑
        _pickerController.delegate = self; //设置代理，检测操作
    }
    return _pickerController;
}

- (UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _showImageView;
}

- (UILabel *)showTitle{
    if (!_showTitle) {
        _showTitle = [[UILabel alloc]init];
        _showTitle.font = [UIFont systemFontOfSize:35];
        [self.view addSubview:_showTitle];
        [_showTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
        _showTitle.textColor = [UIColor redColor];
    }
    return _showTitle;
}

@end
