//
//  ViewController.m
//  ThreadPortTest
//
//  Created by wang on 2019/10/22.
//  Copyright © 2019 Vincent. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "VPortObject.h"
//#import <Foundation/nspo>
#import <Foundation/NSPort.h>

@interface ViewController () <NSMachPortDelegate, NSPortDelegate>
@property (nonatomic, strong) NSPort *myPort;
@property (nonatomic, strong) VPortObject *portObj;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Port线程通讯";
    //1. 创建主线程的port
    // 子线程通过此端口发送消息给主线程
    self.myPort = [NSMachPort port];
    //2. 设置port的代理回调对象
    self.myPort.delegate = self;
    //3. 把port加入runloop，接收port消息
    [[NSRunLoop currentRunLoop] addPort:self.myPort forMode:NSDefaultRunLoopMode];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [NSThread detachNewThreadSelector:@selector(portLaunchThreadWithPort:)
      toTarget:self.portObj
    withObject:self.myPort];
    
}

#pragma mark - NSMachPortDelegate
- (void)handlePortMessage:(NSPortMessage *)message {

    NSLog(@"VC == %@",[NSThread currentThread]);

    NSLog(@"从VPortObject 传过来一些信息:");
//    message.components;
//    NSLog(@"localPort == %@",[message valueForKey:@"localPort"]);
//    NSLog(@"remotePort == %@",[message valueForKey:@"remotePort"]);
//    NSLog(@"receivePort == %@",[message valueForKey:@"receivePort"]);
//    NSLog(@"sendPort == %@",[message valueForKey:@"sendPort"]);
//    NSLog(@"msgid == %@",[message valueForKey:@"msgid"]);
//    NSLog(@"components == %@",[message valueForKey:@"components"]);
    //会报错,没有这个隐藏属性
    //NSLog(@"from == %@",[message valueForKey:@"from"]);

//    NSArray *messageArr = [message valueForKey:@"components"];
//    NSString *dataStr   = [[NSString alloc] initWithData:messageArr.firstObject  encoding:NSUTF8StringEncoding];
//    NSLog(@"传过来一些信息 :%@",dataStr);
//    NSPort  *destinPort = [message valueForKey:@"remotePort"];
//
//    if(!destinPort || ![destinPort isKindOfClass:[NSPort class]]){
//        NSLog(@"传过来的数据有误");
//        return;
//    }
//
//    NSData *data = [@"VC收到!!!" dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSMutableArray *array  =[[NSMutableArray alloc]initWithArray:@[data,self.myPort]];
//
//    // 非常重要,如果你想在Person的port接受信息,必须加入到当前主线程的runloop
//    [[NSRunLoop currentRunLoop] addPort:destinPort forMode:NSDefaultRunLoopMode];
//
//    NSLog(@"VC == %@",[NSThread currentThread]);
//
//    BOOL success = [destinPort sendBeforeDate:[NSDate date]
//                                        msgid:10010
//                                   components:array
//                                         from:self.myPort
//                                     reserved:0];
//    NSLog(@"%d",success);

}


- (void)getAllProperties:(id)somebody{
    
    u_int count = 0;
    objc_property_t *properties = class_copyPropertyList([somebody class], &count);
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
         NSLog(@"%@",[NSString stringWithUTF8String:propertyName]);
    }
}

- (VPortObject *)portObj {
    if (!_portObj) {
        _portObj = [[VPortObject alloc] init];
    }
    return _portObj;
}

@end
