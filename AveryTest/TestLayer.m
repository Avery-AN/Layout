//
//  TestLayer.m
//  AveryTest
//
//  Created by Avery An on 2020/4/4.
//  Copyright © 2020 Avery. All rights reserved.
//

#import "TestLayer.h"

@implementation TestLayer

- (void)layoutSublayers {
    NSLog(@"【 layoutSublayers BEGIN 】");
    NSLog(@"currentThread: %@", [NSThread currentThread]);
    NSLog(@"callStackSymbols: %@", [NSThread callStackSymbols]);
    [NSThread sleepForTimeInterval:2];   // 休眠2秒 (便于log的分析)
    NSLog(@"【 layoutSublayers END 】");
}

@end
