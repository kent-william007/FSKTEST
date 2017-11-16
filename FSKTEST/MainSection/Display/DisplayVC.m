//
//  DisplayVC.m
//  FSKTEST
//
//  Created by kent on 2017/10/27.
//  Copyright © 2017年 kent. All rights reserved.
//

#import "DisplayVC.h"
#import "NSTimer+EOCBlocksSupport.h"

@interface DisplayVC ()

@end

@implementation DisplayVC{
    int index;
    NSTimer *pollTimer;
    NSArray *colorArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc]init];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_equalTo(64);
        make.leading.trailing.equalTo(self.view);
    }];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor blackColor];
    title.text = @"颜色展示";

    
    colorArray = @[[UIColor redColor],
                            [UIColor greenColor],
                            [UIColor blueColor],
                            [UIColor orangeColor],
                            [UIColor purpleColor]];
    
    index = 0;
    __weak DisplayVC *weakSelf = self;
    pollTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:2 block:^{
        DisplayVC *strongSelf = weakSelf;
        [strongSelf p_doPoll];
    } repeats:YES];
}

- (void)p_doPoll {
    NSLog(@"%s",__func__);
    if (index >= colorArray.count) {
        [pollTimer invalidate];
        pollTimer = nil;
        NSLog(@"index:%i",index);
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    self.view.backgroundColor = colorArray[index];
    index++;

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
