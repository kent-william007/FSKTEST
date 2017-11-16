//
//  FSKMainVC.m
//  FSKTEST
//
//  Created by kent on 2017/10/26.
//  Copyright © 2017年 kent. All rights reserved.
//

#import "FSKMainVC.h"
#import "FSKMainViewCell.h"
#import "DisplayVC.h"
#import "BlueToothVC.h"
#import "CameraVC.h"
#import "GravityVC.h"
#import "ButtonVC.h"

#import "AccelerometerViewController.h"
#import "CompassViewController.h"
#import "DeviceMotionViewController.h"
#import "DistanceSensorViewController.h"
#import "FingerprintViewController.h"
#import "GyroscopeViewController.h"
#import "LightSensitiveViewController.h"


#import <AudioToolbox/AudioToolbox.h>

static NSString *CellIdentifier_header = @"CheaderViewHeader_id";
static NSString *CellIdentifier_footer = @"CheaderViewFooter_id";
static NSString *CellIdentifier = @"CellIdentifier";

@interface FSKMainVC()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView *mCollectionView;
@property(nonatomic,strong)NSArray *cellContent_Array;
@end
@implementation FSKMainVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"收银台";
    self.view.backgroundColor = [UIColor blackColor];

    [self initUI];
    _cellContent_Array = @[@{@"keyName":@"display",@"title":@"显示"},
                           @{@"keyName":@"backLight",@"title":@"背光"},
                           @{@"keyName":@"button",@"title":@"按键"},
                           @{@"keyName":@"touchScreen",@"title":@"触摸屏"},
                           @{@"keyName":@"motor",@"title":@"马达"},
                           @{@"keyName":@"sound",@"title":@"声音"},
                           @{@"keyName":@"SDCard",@"title":@"SDCard"},
                           @{@"keyName":@"earphone",@"title":@"耳机"},
                           @{@"keyName":@"blueTooth",@"title":@"蓝牙"},
                           @{@"keyName":@"WIFI",@"title":@"WIFI"},
                           @{@"keyName":@"charge",@"title":@"充电"},
                           @{@"keyName":@"lightTest",@"title":@"光感测"},
                           @{@"keyName":@"distanceTest",@"title":@"距离感测"},
                           @{@"keyName":@"gravityTest",@"title":@"重力感测"},
                           @{@"keyName":@"cameraTakePic",@"title":@"拍照"},
                           @{@"keyName":@"cameraTakeVedio",@"title":@"视频"},
                           ];
    
}

- (void)initUI{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumInteritemSpacing = 10;
    flowlayout.minimumLineSpacing = 10;
    CGFloat itemWidth = (kScreenW-50)/3;
    flowlayout.itemSize = CGSizeMake(itemWidth, itemWidth*0.4);
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowlayout];

    _mCollectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_mCollectionView];
    [_mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(30);
    }];
    _mCollectionView.delegate = self;
    _mCollectionView.dataSource = self;
    
//    [_mCollectionView registerClass:[CheaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier_header];
//    [_mCollectionView registerClass:[FootererView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CellIdentifier_footer];
    [_mCollectionView registerClass:[FSKMainViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *keyName = _cellContent_Array[indexPath.row][@"keyName"];
    if ([keyName isEqualToString:@"display"]) {
        [self presentViewController:[[DisplayVC alloc]init] animated:YES completion:nil];
    }else if ([keyName isEqualToString:@"backLight"]){
        
    }else if ([keyName isEqualToString:@"button"]){
         [self presentViewController:[[ButtonVC alloc]init] animated:YES completion:nil];
    }else if ([keyName isEqualToString:@"touchScreen"]){
        
    }else if ([keyName isEqualToString:@"motor"]){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    }else if ([keyName isEqualToString:@"sound"]){
        AudioServicesPlaySystemSound(1007);
    }else if ([keyName isEqualToString:@"SDCard"]){
        
    }else if ([keyName isEqualToString:@"earphone"]){
        
    }else if ([keyName isEqualToString:@"blueTooth"]){
        [self presentViewController:[[BlueToothVC alloc]init] animated:YES completion:nil];
    }else if ([keyName isEqualToString:@"WIFI"]){
        
    }else if ([keyName isEqualToString:@"charge"]){
        
    }else if ([keyName isEqualToString:@"lightTest"]){
        [self presentViewController:[[LightSensitiveViewController alloc]init] animated:YES completion:nil];
    }else if ([keyName isEqualToString:@"distanceTest"]){
        [self presentViewController:[[DistanceSensorViewController alloc]init] animated:YES completion:nil];
    }else if ([keyName isEqualToString:@"gravityTest"]){
        [self presentViewController:[[AccelerometerViewController alloc]init] animated:YES completion:nil];
    }else if ([keyName isEqualToString:@"cameraTakePic"]){
        
        //设置_pickerController的来源，这里设置为摄像头。
        /*
         UIImagePickerControllerSourceTypePhotoLibrary：照片库
         ，默认值
         UIImagePickerControllerSourceTypeCamera：摄像头
         UIImagePickerControllerSourceTypeSavedPhotosAlbum：相
         */
//        _pickerController.sourceType = self.sourcType;
        //设置摄像头类型
        /*
         UIImagePickerControllerCameraDeviceRear,//后置摄像头
         UIImagePickerControllerCameraDeviceFront //前置摄像头
         */
        
//        _pickerController.cameraDevice = self.cameraType;
        CameraVC *cameravc = [[CameraVC alloc]init];
//        cameravc.sourcType = UIImagePickerControllerSourceTypeCamera;
        cameravc.captureMode = UIImagePickerControllerCameraCaptureModePhoto;
        cameravc.cameraType = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:cameravc animated:YES completion:nil];
    }else if ([keyName isEqualToString:@"cameraTakeVedio"]){
        CameraVC *cameravc = [[CameraVC alloc]init];
        //        cameravc.sourcType = UIImagePickerControllerSourceTypeCamera;
        cameravc.captureMode = UIImagePickerControllerCameraCaptureModeVideo;
        cameravc.cameraType = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:cameravc animated:YES completion:nil];

    }
}
//这个方法是返回 Header的大小 size
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(kScreenW, 130);
//}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    return CGSizeMake(kScreenW, 260);
//}

////这个也是最重要的方法 获取Header的 方法。
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableView = nil;
//    if (kind == UICollectionElementKindSectionHeader) {
//        CheaderView *cell = (CheaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier_header forIndexPath:indexPath];
//        cell.topTitle.text = @"当前收益（CNY）";
//        cell.incomeLab.text = @"¥ 0.01";
//        reusableView = cell;
//    }else if (kind == UICollectionElementKindSectionFooter){
//        FootererView *cell = (FootererView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CellIdentifier_footer forIndexPath:indexPath];
//        [cell.cashierBtn addTarget:self action:@selector(cashierClick:) forControlEvents:UIControlEventTouchUpInside];
//        reusableView = cell;
//    }
//    return reusableView;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _cellContent_Array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSKMainViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    //cell.iconV.image = [UIImage keyNamed:_cellContent_Array[indexPath.row][@"keyName"]];
    cell.titleLab.text = _cellContent_Array[indexPath.row][@"title"];
    cell.highlighted = YES;
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    bgview.backgroundColor = [UIColor redColor];
    cell.selectedBackgroundView = bgview;
    return cell;
}

//- (void)cashierClick:(UIButton *)sender{
//    [self.navigationController pushViewController:[[EnterAmountVC alloc]init] animated:YES];
//}
@end
