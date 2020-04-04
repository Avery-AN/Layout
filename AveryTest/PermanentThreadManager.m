//
//  PermanentThreadManager.m
//  AveryProject
//
//  Created by 我去 on 18/5/1.
//  Copyright © 2018年 an qing. All rights reserved.
//

#import "PermanentThreadManager.h"

@interface PermanentThreadManager() {
    NSRunLoop *_runloop;
    NSTimer *_timeoutTimer;             //超时Timer
    NSTimeInterval _timeoutInterval;    //超时时间
    dispatch_semaphore_t _sem;          //信号量
}
@end

@implementation PermanentThreadManager

#pragma mark - Life Cycle -
- (void)dealloc {
    NSLog(@" %@ - %@",NSStringFromSelector(_cmd), self);
    [self stopLoop];
}

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    _timeoutInterval = 3;
    _sem = dispatch_semaphore_create(0);
    
    return self;
}


#pragma mark - Public Api -
- (id)start {
     self.permanentThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
     [self.permanentThread start];
    
//    dispatch_semaphore_wait(_sem, DISPATCH_TIME_FOREVER);
    
    return @(YES);
}


#pragma mark - Private Methods -
- (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"Avery-PermanentThread"];
        
        _runloop = [NSRunLoop currentRunLoop];
        [_runloop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
        [_runloop run];
        
//        /*
//         【这里只是演示超时cancel runloop的操作,实际项目中一定有其他主动cancel runloop的操作,比如网络请求成功或失败后需要进行cancel操作。】
//         */
//        _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:_timeoutInterval target:self selector:@selector(stopLoop) userInfo:nil repeats:NO];
//        [_runloop addTimer:_timeoutTimer forMode:NSRunLoopCommonModes];
//        [_runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:(_timeoutInterval+5)]];
    }
}

- (void)stopLoop {
    if (_runloop) {
        CFRunLoopStop([_runloop getCFRunLoop]);
        dispatch_semaphore_signal(_sem);
    }
}

@end
