//
//  PzMonitor.h
//  PzKit
//
//  Created by sos1a2a3a on 2020/1/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PzMonitor : NSObject

+ (instancetype)shareInstance;

//开始监视
- (void)startMonitor;
//停止监视
- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
