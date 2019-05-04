####1.数组越界
**示例：**
```
NSArray *array = @[@"0",@"1"];
NSLog(@"array:%@",array[2]);
```
**crash提示：**
```
*** Terminating app due to uncaught exception 'NSRangeException', 
reason: '*** -[__NSArrayI objectAtIndexedSubscript:]: index 2 beyond bounds [0 .. 1]'
```
**原因：**
数组只有两个元素，要访问第三个元素，超出数组的内存地址，所以系统会crash。

**解决办法：**
```
//判断数组元素个数，保证数组不越界
NSArray *array = @[@"0",@"1"];
if (array.count <= 2) {
return;
}
NSLog(@"arrayOutRange:%@",array[2]);
```
####2.数组、字典插入空值
**示例2.1：**
```
NSMutableArray *array = [NSMutableArray array];
NSString *nilString = nil;
[array addObject:nilString];
NSLog(@"arrayInsertNil");
```
**crash提示2.1：**
```
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', 
reason: '*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil' *** 
```
**原因：**
数组不能插入空值，会产生crash。
**解决办法：**
```
if (nilString != nil) {
[array addObject:nilString];
}
```
**示例2.2：**
```
NSMutableDictionary *dict = [NSMutableDictionary dictionary];
NSString *nilString = nil;
[dict setObject:@"dict" forKey:nilString];//object为空
//    [dict setObject:nilString forKey:@"dict"];//key为空
//    [dict objectForKey:nilString];//key为空
NSLog(@"dictionaryInsertNil");
```
**crash提示2.2：**
```
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', 
reason: '*** -[__NSDictionaryM setObject:forKey:]: object cannot be nil (key: dict)'
```
**原因：**
字典的key和object都不能为空值，会产生crash。
**解决办法：**
```
if (nilString != nil) {
[dict setObject:@"dict" forKey:nilString];
}
```

####3.block为空
**示例：**
```
void(^block)(void) = nil;
block();
```
**crash提示：**
```
Thread 1: EXC_BAD_ACCESS (code=1, address=0x10)
```
**原因：**
当block为空时，访问错误地址，产生crash。
**解决办法：**
```
if (block) {
block()
}
```
####4.调用未实现方法
**示例4.1：**
```
[self performSelector:@selector(methodXXX)];
```
**crash提示4.1：**
```
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', 
reason: '-[ViewController method]: unrecognized selector sent to instance
```
**原因：**
由于self没有实现methodXXX方法，所以会产生crash
**解决办法：**
```
if ([self respondsToSelector:@selector(method)]) {
[self performSelector:@selector(method)];
}
```
**示例4.2：**
```
//ViewController.h
@protocol ViewControllerDelegate <NSObject>

- (void)vcDeletegate;

@end

@interface ViewController : UIViewController

@property (nonatomic, weak)id<ViewControllerDelegate> deletegate;

@end

//ViewController.m
[self.deletegate vcDeletegate];
```
**crash提示4.2：**
```
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', 
reason: '-[ViewController vcDeletegate]: unrecognized selector sent to instance
```
**原因：**
没有实现代理方法，所以导致crash。
**解决办法：**
```
if ([self.delegate respondsToSelector:@selector(vcDeletegate)]) {
[self.deletegate vcDeletegate];
}
```
####5. NSNotification crash
**示例：**
```
//  XMNotoficationObject.m
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

//  ViewController.m

- (void)notificationCrash
{
XMNotoficationObject *xmObject = [[XMNotoficationObject alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
[super viewDidAppear:animated];
[[NSNotificationCenter defaultCenter] postNotificationName:@"XMNotoficationObject" object:nil];
}
```
**crash提示：**
```
Thread 1: EXC_BAD_ACCESS (code=1, address=0x8)
```
**原因：**
当一个对象添加了notification之后，如果dealloc的时候，仍然持有notification，就会出现NSNotification类型的crash。

所幸的是，苹果在iOS9之后专门针对于这种情况做了处理，所以在iOS9之后，即使开发者没有移除observer，Notification crash也不会再产生了。
**解决办法：**
```
//  XMNotoficationObject.m
- (void)dealloc
{
[[NSNotificationCenter defaultCenter] removeObserver:self];
}
```
####6.NSString crash
**示例：**
```
NSRange range = NSMakeRange(2, 1);
NSString *string = @"01";
NSLog(@"NSString:%@",[string substringWithRange:range]);
```
**crash提示：**
```
*** Terminating app due to uncaught exception 'NSRangeException', 
reason: '-[__NSCFConstantString substringWithRange:]: Range {2, 1} out of bounds; string length 2'
```
**原因：**
访问范围超出string的长度，地址越界。
**解决办法：**
```
保证range不能越界，可以使用range.location和range.length判断
```
####7.KVO crash
**示例：**
```
//  XMKvoObjectA.h
@property (nonatomic, strong) XMKvoObjectB * objectB;
//  XMKvoObjectA.m
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

//  XMKvoObjectB.h
@property (nonatomic, assign) NSInteger num;

//  ViewController.m
@property (nonatomic, strong) XMKvoObjectB * objectB;
- (void)viewDidAppear:(BOOL)animated
{
[super viewDidAppear:animated];
self.objectB.num = 1;
}
- (void)kvoCrash
{
XMKvoObjectA *kvoObjectA = [[XMKvoObjectA alloc] init];
kvoObjectA.objectB = self.objectB;
}
```
**crash提示：**
```
*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', 
reason: 'An instance 0x7d1a0130 of class XMKvoObjectA was deallocated while key value observers were still registered with it.
Current observation info: <NSKeyValueObservationInfo 0x7d1a6750> (
<NSKeyValueObservance 0x7d1a7670: Observer: 0x0, Key path: num, Options: <New: YES, Old: NO, Prior: NO> Context: 0x0, Property: 0x7d1a6710>
)'
```
**原因：**
KVO的被观察者(XMKvoObjectA)dealloc时仍然注册着KVO导致的crash

同时KVO重复添加观察者（addObserver）或重复移除观察者（removeObserver）也会导致的crash。
**解决办法：**
```
参看faceBook的KVOController实现
```
####8.UITableView滚动越界
**示例：**
```
- (void)tableviewScrollOutRange
{
[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
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

```
**crash提示：**
```
*** Terminating app due to uncaught exception 'NSRangeException', 
reason: '-[UITableView _contentOffsetForScrollingToRowAtIndexPath:atScrollPosition:]: section (2) beyond bounds (1).'
```
**原因：**
tableview只有一个section和一个row，但是要滚动到第2个section，超出range了。
**解决办法：**
```
if (self.tableView.numberOfSections > 2 && [self.tableView numberOfRowsInSection:2] > 1) {
[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}
```

####9.
**示例：**
```
NSString *nilString = nil;
NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:nilString];
NSLog(@"attributedString:%@",attributedString);
```
**crash提示：**
```
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', 
reason: 'NSConcreteAttributedString initWithString:: nil value'
```
**原因：**
不能用nil来初始化NSAttributedString，否则会crash。
**解决办法：**
```
if (nilString != nil) {
NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:nilString];
}
```
总结：
在日常业务开发过程中，要多思考异常情况，对于一些动态值，必须加上保护，防止crash的产生。
