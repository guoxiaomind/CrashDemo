//
//  XMNotoficationObject.m
//  CrashDemo
//
//  Created by 郭孝民 on 2019/5/4.
//  Copyright © 2019年 xiaominge. All rights reserved.
//

#import "XMNotoficationObject.h"

@implementation XMNotoficationObject

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification) name:@"XMNotoficationObject" object:nil];
    }
    return self;
}

- (void)notification
{
    NSLog(@"notification");
}

@end
