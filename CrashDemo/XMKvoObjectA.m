//
//  XMKvoObjectA.m
//  CrashDemo
//
//  Created by 郭孝民 on 2019/5/4.
//  Copyright © 2019年 xiaominge. All rights reserved.
//

#import "XMKvoObjectA.h"

@implementation XMKvoObjectA

//- (void)dealloc {
//    // KVO反注册
//    [self removeObserver:self.objectB forKeyPath:@"num"];
//}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        [self addObserver:self.objectB forKeyPath:@"num" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"observeValueForKeyPath:%@",object);
}

@end
