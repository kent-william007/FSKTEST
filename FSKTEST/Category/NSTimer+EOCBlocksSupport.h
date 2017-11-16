//
//  NSTimer+EOCBlocksSupport.h
//  timerButton
//
//  Created by kent on 2017/7/27.
//  Copyright © 2017年 kent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (EOCBlocksSupport)
+ (NSTimer*)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;
@end
