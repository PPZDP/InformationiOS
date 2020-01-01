//
//  PzMonitor.m
//  PzKit
//
//  Created by sos1a2a3a on 2020/1/1.
//

#import "PzMonitor.h"
#import "PZCPUMonitor.h"
#import "BSBacktraceLogger.h"

@interface PzMonitor (){
    int timeoutCount;
    CFRunLoopObserverRef runLoopObserver;
@public
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runLoopActivity;
}
@property (nonatomic, strong) NSTimer *cpuMonitorTimer;
@end

@implementation PzMonitor

#pragma mark - Interface
+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
#pragma mark - Public

- (void)startMonitor{
    
    self.cpuMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                            target:self
                                                          selector:@selector(updateCPUInfo)
                                                          userInfo:nil
                                                           repeats:YES];
    
    //监测卡顿
    if (runLoopObserver) {
        return;
    }
    dispatchSemaphore = dispatch_semaphore_create(0); //Dispatch Semaphore保证同步
    //创建一个观察者
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                              kCFRunLoopAllActivities,
                                              YES,
                                              0,
                                              &runLoopObserverCallBack,
                                              &context);
    //将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    //创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //子线程开启一个持续的loop用来进行监控
        while (YES) {
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->runLoopObserver) {
                    self->timeoutCount = 0;
                    self->dispatchSemaphore = 0;
                    self->runLoopActivity = 0;
                    return;
                }
            //两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                if (self->runLoopActivity == kCFRunLoopBeforeSources || self->runLoopActivity == kCFRunLoopAfterWaiting) {
                    
                    if (++self->timeoutCount < 3) {
                        continue;
                    }
                    
                    NSLog(@"monitor trigger");
                    NSString *str =  [BSBacktraceLogger bs_backtraceOfMainThread];
                    NSLog(@"%@",str);
                }
            }
            self->timeoutCount = 0;
        }
    });
}

- (void)endMonitor{
    [self.cpuMonitorTimer invalidate];
    if (!runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}


#pragma mark - Private
- (void)updateCPUInfo {
    [PZCPUMonitor updateCPU];
}
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    PzMonitor *lagMonitor = (__bridge PzMonitor*)info;
    lagMonitor->runLoopActivity = activity;
    dispatch_semaphore_t semaphore = lagMonitor->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

@end
