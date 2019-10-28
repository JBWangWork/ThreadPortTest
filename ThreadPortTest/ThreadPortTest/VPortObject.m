//
//  VPortObject.m
//  ThreadPortTest
//
//  Created by wang on 2019/10/22.
//  Copyright © 2019 Vincent. All rights reserved.
//

#import "VPortObject.h"
#import <objc/runtime.h>
#import <Foundation/NSPort.h>

@interface VPortObject() <NSMachPortDelegate>
@property (nonatomic, strong) NSPort *vcPort;
@property (nonatomic, strong) NSPort *myPort;
@end

@implementation VPortObject

- (void)portLaunchThreadWithPort:(NSPort *)port {
    NSLog(@"VC 响应了VPortObject里面");
    @autoreleasepool {
        //1. 保存主线程传入的port
        self.vcPort = port;
        //2. 设置子线程名字
        [[NSThread currentThread] setName:@"VPortObjectThread"];
        //3. 开启runloop
        [[NSRunLoop currentRunLoop] run];
        //4. 创建自己port
        self.myPort = [NSMachPort port];
        //5. 设置port的代理回调对象
        self.myPort.delegate = self;
        //6. 完成向主线程port发送消息
        [self sendPortMessage];
    }
}

/**
 *   完成向主线程发送port消息
 */

- (void)sendPortMessage {
 
    NSData *data1 = [@"Gavin" dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableArray *array  =[[NSMutableArray alloc]initWithArray:@[data1,self.myPort]];
    // 发送消息到VC的主线程
    // 第一个参数：发送时间。
    // msgid 消息标识。
    // components，发送消息附带参数。
    // reserved：为头部预留的字节数
    [self.vcPort sendBeforeDate:[NSDate date]
                          msgid:10086
                     components:array
                           from:self.myPort
                       reserved:0];
    
}

#pragma mark - NSMachPortDelegate

- (void)handlePortMessage:(NSPortMessage *)message {
    
    NSLog(@"person:handlePortMessage  == %@",[NSThread currentThread]);

    NSLog(@"从VC 传过来一些信息:");
    NSArray *messageArr = [message valueForKey:@"components"];
    NSString *dataStr   = [[NSString alloc] initWithData:messageArr.firstObject  encoding:NSUTF8StringEncoding];
    NSLog(@"components == %@ --%@",[message valueForKey:@"components"], dataStr);
    NSLog(@"receivePort == %@",[message valueForKey:@"receivePort"]);
    NSLog(@"sendPort == %@",[message valueForKey:@"sendPort"]);
    NSLog(@"msgid == %@",[message valueForKey:@"msgid"]);
}
@end
