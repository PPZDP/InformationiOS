//
//  PzCrashUncaughtExceptionHandler.m
//  PzKit
//
//  Created by sos1a2a3a on 2020/1/1.
//

#import "PzCrashUncaughtExceptionHandler.h"

// 记录之前的崩溃回调函数
static NSUncaughtExceptionHandler *previousUncaughtExceptionHandler = NULL;

@implementation PzCrashUncaughtExceptionHandler

#pragma mark - Register

+ (void)registerHandler {
    // Backup original handler
    previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    
    NSSetUncaughtExceptionHandler(&PzUncaughtExceptionHandler);
}

#pragma mark - Private

// 崩溃时的回调函数
static void PzUncaughtExceptionHandler(NSException * exception) {
    // 异常的堆栈信息
    NSArray * stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString * reason = [exception reason];
    // 异常名称
    NSString * name = [exception name];
    
    NSString * exceptionInfo = [NSString stringWithFormat:@"========uncaughtException异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@", name, reason, [stackArray componentsJoinedByString:@"\n"]];
    
    NSLog(@"%@",exceptionInfo);
    
    // 调用之前崩溃的回调函数
    if (previousUncaughtExceptionHandler) {
        previousUncaughtExceptionHandler(exception);
    }
    
    // 杀掉程序，这样可以防止同时抛出的SIGABRT被SignalException捕获
    kill(getpid(), SIGKILL);
}

@end
