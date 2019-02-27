//
//  ViewController.m
//  BFSRuntime
//
//  Created by 刘玲 on 2019/2/18.
//  Copyright © 2019年 BFS. All rights reserved.
//

#import "ViewController.h"
#import "BFSParent.h"
#import "BFSRuntimer.h"

@interface ViewController () {
    BFSParent *parents;
    BFSRuntimer *runtimer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testKVO];
    [self testRuntime];
}

// Runtime
- (void)testRuntime {
    
    runtimer = [[BFSRuntimer alloc] init];
//    [runtimer testRuntime_SendMsg];
    [runtimer testRuntime_InterceptMethods];
//    [BFSRuntimer addInstanceMethod:@selector(instanceMethod)];
//    [runtimer testRuntime_AddNewMethod];
}

// KVO
- (void)testKVO {
    
    parents = [[BFSParent alloc] init];
    [parents raisingOneChildrenForName:@"Alex"];
    
    // KVC
    [parents.children setValue:@(12) forKey:@"age"];
    NSLog(@"age: %d", parents.children.age);
    
    __weak BFSParent *weakParent = parents;
    [NSTimer scheduledTimerWithTimeInterval:2.f repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakParent.children increaseOneYear];
    }];
}



@end
