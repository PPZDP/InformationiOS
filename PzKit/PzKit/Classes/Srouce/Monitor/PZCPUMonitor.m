//
//  PZCPUMonitor.m
//  PzKit
//
//  Created by sos1a2a3a on 2020/1/1.
//

#import "PZCPUMonitor.h"
#import "BSBacktraceLogger.h"
#include <mach/mach.h>
@implementation PZCPUMonitor

+ (void)updateCPU {
    //https://www.jianshu.com/p/f4359eb9529a
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount = 0;
    const task_t thisTask = mach_task_self();
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    if (kr != KERN_SUCCESS) {
        return;
    }
    for (int i = 0; i < threadCount; i++) {
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        if (thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
            threadBaseInfo = (thread_basic_info_t)threadInfo;
            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                integer_t cpuUsage = threadBaseInfo->cpu_usage / 10;
                if (cpuUsage > 60) {
                 NSString *reStr = [BSBacktraceLogger bs_backtraceOfNSThreadForThread_t:threads[i]];
                    NSLog(@"CPU useage overload thread stack：\n%@",reStr);
                }
            }
        }
    }
}


@end
