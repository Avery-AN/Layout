//
//  RootViewController.m
//  AveryTest
//
//  Created by Avery An on 2019/12/17.
//  Copyright © 2019 Avery. All rights reserved.
//

#import "RootViewController.h"
#import "PermanentThreadManager.h"
#import "TestLayer.h"

@interface RootViewController ()
@property (nonatomic) TestLayer *subLayer;
@property (nonatomic) PermanentThreadManager *permanentThreadManager;
@end

static void QARunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    /**
     kCFRunLoopEntry = (1UL << 0),
     kCFRunLoopBeforeTimers = (1UL << 1),
     kCFRunLoopBeforeSources = (1UL << 2),
     kCFRunLoopBeforeWaiting = (1UL << 5),
     kCFRunLoopAfterWaiting = (1UL << 6),
     kCFRunLoopExit = (1UL << 7),
     */
    switch (activity) {
        case 1:
            NSLog(@"%ld - Entry;  Thread: %@;  Mode:%@", activity, [NSThread currentThread].name, [NSRunLoop currentRunLoop].currentMode);
            break;
        case 2:
            NSLog(@"%ld - BeforeTimers;  Thread: %@;  Mode:%@", activity, [NSThread currentThread].name, [NSRunLoop currentRunLoop].currentMode);
            break;
        case 4:
            NSLog(@"%ld - BeforeSources;  Thread: %@;  Mode:%@", activity, [NSThread currentThread].name, [NSRunLoop currentRunLoop].currentMode);
            break;
        case 32:
            NSLog(@"%ld - BeforeWaiting;  Thread: %@;  Mode:%@", activity, [NSThread currentThread].name, [NSRunLoop currentRunLoop].currentMode);
            break;
        case 64:
            NSLog(@"%ld - AfterWaiting;  Thread: %@;  Mode:%@", activity, [NSThread currentThread].name, [NSRunLoop currentRunLoop].currentMode);
            break;
        case 128:
            NSLog(@"%ld - Exit;  Thread: %@;  Mode:%@", activity, [NSThread currentThread].name, [NSRunLoop currentRunLoop].currentMode);
            break;
            
        default:
            break;
    }
    NSLog(@" ");
}
static void QAObserverSetup_runloop(CFRunLoopRef runloop) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFRunLoopObserverRef observer;
        observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                           kCFRunLoopAllActivities,
                                           true,        // repeat
                                           0,           // 设定观察者的优先级
                                           QARunLoopObserverCallBack,
                                           NULL);
        CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
}


@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.subLayer = [[TestLayer alloc] init];
    self.subLayer.backgroundColor = [UIColor grayColor].CGColor;
    self.subLayer.frame = CGRectMake(100, 100, 200, 100);
    [self.view.layer addSublayer:self.subLayer];
    
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    button0.backgroundColor = [UIColor blueColor];
    button0.frame = CGRectMake(100, 230, 200, 40);
    [button0 setTitle:@"Default" forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(tapAction0) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor brownColor];
    button.frame = CGRectMake(60, 320, 280, 40);
    [button setTitle:@"layoutIfNeeded   (临时子线程)" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor brownColor];
    button2.frame = CGRectMake(60, 380, 280, 40);
    [button2 setTitle:@"setNeedsLayout   (临时子线程)" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(tapAction2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.backgroundColor = [UIColor brownColor];
    button3.frame = CGRectMake(60, 440, 280, 40);
    [button3 setTitle:@"CATransaction   (临时子线程)" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(tapAction3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button_ = [UIButton buttonWithType:UIButtonTypeCustom];
    button_.backgroundColor = [UIColor brownColor];
    button_.frame = CGRectMake(60, 530, 280, 40);
    [button_ setTitle:@"layoutIfNeeded   (常驻子线程)" forState:UIControlStateNormal];
    [button_ addTarget:self action:@selector(tapAction_) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_];
    
    UIButton *button2_ = [UIButton buttonWithType:UIButtonTypeCustom];
    button2_.backgroundColor = [UIColor brownColor];
    button2_.frame = CGRectMake(60, 590, 280, 40);
    [button2_ setTitle:@"setNeedsLayout   (常驻子线程)" forState:UIControlStateNormal];
    [button2_ addTarget:self action:@selector(tapAction2_) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2_];
    
    UIButton *button3_ = [UIButton buttonWithType:UIButtonTypeCustom];
    button3_.backgroundColor = [UIColor brownColor];
    button3_.frame = CGRectMake(60, 650, 280, 40);
    [button3_ setTitle:@"CATransaction   (常驻子线程)" forState:UIControlStateNormal];
    [button3_ addTarget:self action:@selector(tapAction3_) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3_];
    
    
    UIButton *button_00 = [UIButton buttonWithType:UIButtonTypeCustom];
    button_00.backgroundColor = [UIColor blueColor];
    button_00.frame = CGRectMake(100, 760, 200, 40);
    [button_00 setTitle:@"getSubThread" forState:UIControlStateNormal];
    [button_00 addTarget:self action:@selector(getSubThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_00];
    
}

- (void)tapAction0 {
    self.subLayer.backgroundColor = [UIColor grayColor].CGColor;
}

- (void)tapAction {
    /**
     _pthread_exit -> CA::Transaction::release_thread -> CA::Transaction::commit()
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"currentThread: %@",[NSThread currentThread]);
        [self.subLayer layoutIfNeeded];   // 不会触发layoutSublayers
    });
    
    
    /**
     _pthread_exit -> CA::Transaction::release_thread -> CA::Transaction::commit()
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"currentThread: %@",[NSThread currentThread]);
        self.subLayer.backgroundColor = [UIColor orangeColor].CGColor;
        [self.subLayer layoutIfNeeded];   // 不会触发layoutSublayers
    });
}
- (void)tapAction2 {
    /**
     _pthread_exit -> _pthread_tsd_cleanup -> CA::Transaction::release_thread
    */
    __block NSInteger num = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        num++;
    });
    
    
    /**
     CA::Transaction::release_thread -> CA::Transaction::commit() ->
     CA::Context::commit_transaction(CA::Transaction*, double) -> CA::Layer::layout_and_display_if_needed(CA::Transaction*) ->
     CA::Layer::layout_if_needed(CA::Transaction*) -> layoutSublayers
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.subLayer setNeedsLayout];   // 会触发layoutSublayers
    });
    
    
    /**
    CA::Transaction::release_thread -> CA::Transaction::commit() ->
    CA::Context::commit_transaction(CA::Transaction*, double) -> CA::Layer::layout_and_display_if_needed(CA::Transaction*) ->
    CA::Layer::layout_if_needed(CA::Transaction*) -> layoutSublayers
    */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.subLayer.backgroundColor = [UIColor orangeColor].CGColor;
        [self.subLayer setNeedsLayout];   // 会触发layoutSublayers
    });
    
    
    /**
     CA::Transaction::release_thread -> CA::Transaction::commit()
    */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.subLayer.backgroundColor = [UIColor orangeColor].CGColor;  // 不会触发layoutSublayers
    });
}
- (void)tapAction3 {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.subLayer.backgroundColor = [UIColor orangeColor].CGColor;
        [CATransaction commit];
    });
}
- (void)tapAction_ {
    [self performSelector:@selector(layer_layoutIfNeeded) withObject:nil afterDelay:2];
}

- (void)layer_layoutIfNeeded {
    if (!self.permanentThreadManager) {
        self.permanentThreadManager = [PermanentThreadManager new];
        [self.permanentThreadManager start];
    }
    [self performSelector:@selector(permanentThreadAction_) onThread:self.permanentThreadManager.permanentThread withObject:nil waitUntilDone:NO];
}
//- (void)permanentThreadAction_ {
//    QAObserverSetup_runloop(CFRunLoopGetCurrent());  // 监听当前线程的runloop
//    self.subLayer.backgroundColor = [UIColor orangeColor].CGColor;
//    NSLog(@"开始调用layoutIfNeeded:");
//    [self.subLayer layoutIfNeeded];
//    NSLog(@"layoutIfNeeded调用完毕!");
//    [NSThread sleepForTimeInterval:6];
//    NSLog(@"休眠结束");
//}
//- (void)permanentThreadAction_ {
//    QAObserverSetup_runloop(CFRunLoopGetCurrent());  // 监听当前线程的runloop
//
//    NSLog(@"currentThread: %@",[NSThread currentThread]);
//    CALayer *layer = [[CALayer alloc] init];
//    layer.frame = CGRectMake(10, 10, 10, 10);
//    layer.backgroundColor = [UIColor yellowColor].CGColor;
//    [self.subLayer addSublayer:layer];
//
//    NSLog(@"开始调用layoutIfNeeded:");
//    [self.subLayer layoutIfNeeded];
//    NSLog(@"layoutIfNeeded调用完毕!");
//    [NSThread sleepForTimeInterval:6];
//    NSLog(@"休眠结束");
//}

- (void)permanentThreadAction_ {
    QAObserverSetup_runloop(CFRunLoopGetCurrent());  // 监听当前线程的runloop

    NSLog(@"currentThread: %@",[NSThread currentThread]);
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(10, 10, 10, 10);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.subLayer addSublayer:layer];

    NSLog(@"开始调用layoutIfNeeded:");
    [self.subLayer layoutIfNeeded];
    NSLog(@"layoutIfNeeded调用完毕!");
    [NSThread sleepForTimeInterval:6];
    NSLog(@"休眠结束");
    /**
     当调用layoutSubviews方法之后、更新后的UI显示到当前的view(layer)上的时机仍然是等到当前线程休眠或者退出时。 通过调用 __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__   ->  CA::Transaction::observer_callback  ->
     CA::Transaction::commit()等方法 进行渲染。如果想立即进行UI的渲染则需要将layoutIfNeeded方法替换为:"[CATransaction commit];"。
     */
}

//- (void)permanentThreadAction_ {
//    QAObserverSetup_runloop(CFRunLoopGetCurrent());  // 监听当前线程的runloop
//
//    NSLog(@"currentThread: %@",[NSThread currentThread]);
//    CALayer *layer = [[CALayer alloc] init];
//    layer.frame = CGRectMake(10, 10, 10, 10);
//    layer.backgroundColor = [UIColor yellowColor].CGColor;
//    [self.subLayer addSublayer:layer];
//
//    NSLog(@"开始调用layoutIfNeeded:");
//    [CATransaction commit];
//    NSLog(@"layoutIfNeeded调用完毕!");
//    [NSThread sleepForTimeInterval:6];
//    NSLog(@"休眠结束");
//}


- (void)tapAction2_ {
    if (!self.permanentThreadManager) {
        self.permanentThreadManager = [PermanentThreadManager new];
        [self.permanentThreadManager start];
    }
    [self performSelector:@selector(permanentThreadAction2_) onThread:self.permanentThreadManager.permanentThread withObject:nil waitUntilDone:NO];
}
//- (void)permanentThreadAction2_ {
//    QAObserverSetup_runloop(CFRunLoopGetCurrent());  // 监听当前线程的runloop
//    self.subLayer.backgroundColor = [UIColor orangeColor].CGColor;
//    [self.subLayer setNeedsLayout];  // 当前线程休眠或退出时通过CATransaction的回调进行更新  (会触发layoutSublayers方法)
//}

- (void)permanentThreadAction2_ {
    QAObserverSetup_runloop(CFRunLoopGetCurrent());  // 监听当前线程的runloop
    /**
     __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__ -> CA::Transaction::observer_callback
     -> CA::Transaction::commit() -> layoutSublayers
     */
    [self.subLayer setNeedsLayout];  // 当前线程休眠或退出时通过CATransaction的回调进行更新  (这样也会触发layoutSublayers方法)
}

- (void)tapAction3_ {
    if (!self.permanentThreadManager) {
        self.permanentThreadManager = [PermanentThreadManager new];
        [self.permanentThreadManager start];
    }
    [self performSelector:@selector(permanentThreadAction3_) onThread:self.permanentThreadManager.permanentThread withObject:nil waitUntilDone:NO];
}
- (void)permanentThreadAction3_ {
    QAObserverSetup_runloop(CFRunLoopGetCurrent());  // 监听当前线程的runloop
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(10, 10, 10, 10);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.subLayer addSublayer:layer];
    [CATransaction commit];
    NSLog(@"开始休眠。。。");
    [NSThread sleepForTimeInterval:12];
    NSLog(@"休眠结束。。。");
}

- (void)getSubThread {
    for (int i = 0; i < 120; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"去GCD线程池请求新的临时子线程。。。 i: %d", i);
            [NSThread sleepForTimeInterval:0.3];
        });
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
