//
//  PermanentThreadManager.h
//  AveryProject
//
//  Created by 我去 on 18/5/1.
//  Copyright © 2018年 an qing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermanentThreadManager : NSObject

@property (nonatomic) NSThread *permanentThread;

- (id)start;

@end
