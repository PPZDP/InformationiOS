//
//  PZViewController.m
//  PzKit
//
//  Created by sawrysc@163.com on 01/01/2020.
//  Copyright (c) 2020 sawrysc@163.com. All rights reserved.
//

#import "PZViewController.h"

@interface PZViewController ()

@property (nonatomic, assign) BOOL highCPU;
@property (nonatomic, strong) NSThread *cpuThread;

@end

@implementation PZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
}

- (void)clickBtn{
    //@"卡顿操作"
    //    [NSThread sleepForTimeInterval:5.0];
    
    
    //监测CPU
    _highCPU = !_highCPU;
    if (_highCPU) {
        _cpuThread = [[NSThread alloc] initWithTarget:self selector:@selector(highCPUOperate) object:nil];
        _cpuThread.name = @"HighCPUThread";
        [_cpuThread start];

    }else{
        [_cpuThread cancel];
        _cpuThread = nil;
    }
    
    //crash
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:nil];
}


- (void)highCPUOperate{
    while (TRUE) {
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
