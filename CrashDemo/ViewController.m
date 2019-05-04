//
//  ViewController.m
//  CrashDemo
//
//  Created by 郭孝民 on 2019/5/1.
//  Copyright © 2019年 xiaominge. All rights reserved.
//

#import "ViewController.h"
#import "XMNotoficationObject.h"
#import "XMKvoObjectA.h"
#import "XMKvoObjectB.h"

@interface ViewController ()<ViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) XMKvoObjectB * objectB;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //只是做个做个演示，正常不会把代理设成自己。
    self.deletegate = self;

//    //1.数组越界
//    [self arrayOutRange];
//
//    //2.数组、字典插入空值
//    [self arrayInsertNil];
//    [self dictionaryInsertNil];
//
//    //3.block为空
//    [self blockNil];
//
//    //4.调用未实现方法
//    [self unDefindedMethod];
//
//    //5.通知 crash
//    [self notificationCrash];
//
//    //6.KVO crash
//    [self kvoCrash];
//
//    //7.string越界
//    [self stringOutRange];
//
//    //8.UITableView滚动越界
//    [self tableviewScrollOutRange];
//
//    //9.NSAttributedString初始化为空值
//    [self attributedStringNil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XMNotoficationObject" object:nil];
    self.objectB.num = 1;
}

//1.数组越界
- (void)arrayOutRange
{
    NSArray *array = @[@"0",@"1"];
    NSLog(@"arrayOutRange:%@",array[2]);
}

//2.数组、字典插入空值
//2.1数组插入空值
- (void)arrayInsertNil
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *nilString = nil;
    [array addObject:nilString];
    NSLog(@"arrayInsertNil");
}
//2.2字典插入空值
- (void)dictionaryInsertNil
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *nilString = nil;
    [dict setObject:@"dict" forKey:nilString];
//    [dict setObject:nilString forKey:@"dict"];
//    [dict objectForKey:nilString];
    NSLog(@"dictionaryInsertNil");
}

//3.block为空
- (void)blockNil
{
    void(^block)(void) = nil;
    block();
}

//4.调用未实现方法
- (void)unDefindedMethod
{
//    [self performSelector:@selector(method)];
    [self.deletegate vcDeletegate];
    
}

//5.通知 crash
- (void)notificationCrash
{
    XMNotoficationObject *xmObject = [[XMNotoficationObject alloc] init];
    NSLog(@"notificationCrash:%@",xmObject);
}

//6.KVO crash
- (void)kvoCrash
{
    XMKvoObjectA *kvoObjectA = [[XMKvoObjectA alloc] init];
    kvoObjectA.objectB = self.objectB;
}

//7.string越界
- (void)stringOutRange
{
    NSRange range = NSMakeRange(2, 1);
    NSString *string = @"01";
    NSLog(@"stringOutRange:%@",[string substringWithRange:range]);
}

//8.UITableView滚动越界
- (void)tableviewScrollOutRange
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

//9.NSAttributedString初始化为空值
- (void)attributedStringNil
{
    NSString *nilString = nil;
    if (nilString != nil) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:nilString];
    }
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:nilString];
    NSLog(@"attributedString:%@",attributedString);
}


#pragma tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
