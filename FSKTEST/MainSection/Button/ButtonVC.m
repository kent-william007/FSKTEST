//
//  ButtonVC.m
//  FSKTEST
//
//  Created by kent on 2017/11/6.
//  Copyright © 2017年 kent. All rights reserved.
//

#import "ButtonVC.h"
#import "KKAudioControlManager.h"
#import "KKAudioLongPressListener.h"

extern NSString * KKAudioControlVolumeBiggerNotification;
extern NSString * KKAudioControlVolumeSmallerNotification;
extern NSString * KKAudioControlMuteTurnOnNotification;
extern NSString * KKAudioControlMuteTurnOffNotification;

@implementation ButtonVC{
    UILabel *tipsLable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    tipsLable = [[UILabel alloc]init];
    [self.view addSubview:tipsLable];
    [tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.leading.trailing.equalTo(self.view);
    }];
    tipsLable.font = [UIFont systemFontOfSize:18];
    tipsLable.textColor = [UIColor lightGrayColor];

    
    [self regNotifi];
    
    [[KKAudioControlManager shareInstance] addVolumeListener];
    [[KKAudioControlManager shareInstance] addMuteListener];
    
    [KKAudioLongPressListener beginListen];
}




#pragma mark - audio

- (void)audioControlVolumeBigger
{
    NSLog(@"volume ++ ");
    tipsLable.text = @"请调小音量";
}

- (void)audioControlVolumeSmaller
{
    NSLog(@"volume -- ");
    tipsLable.text = @"请调大音量";
}

- (void)audioControlMuteTurnOn
{
    NSLog(@"mute on");
    tipsLable.text = @"请关闭静音键";
}
- (void)audioControlMuteTurnOff
{
    NSLog(@"mute off");
    tipsLable.text = @"请打开静音键";
}

- (void)regNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioControlVolumeBigger)
                                                 name:KKAudioControlVolumeBiggerNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioControlVolumeSmaller)
                                                 name:KKAudioControlVolumeSmallerNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioControlMuteTurnOn)
                                                 name:KKAudioControlMuteTurnOnNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioControlMuteTurnOff)
                                                 name:KKAudioControlMuteTurnOffNotification
                                               object:nil];
}

@end
