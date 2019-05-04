//
//  ViewController.h
//  CrashDemo
//
//  Created by 郭孝民 on 2019/5/1.
//  Copyright © 2019年 xiaominge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDelegate <NSObject>

@optional
- (void)vcDeletegate;

@end

@interface ViewController : UIViewController

@property (nonatomic, weak)id<ViewControllerDelegate> deletegate;

@end

