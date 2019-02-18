//
//  BFSRuntimer.h
//  BFSRuntime
//
//  Created by 刘玲 on 2019/2/18.
//  Copyright © 2019年 BFS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFSRuntimer : NSObject

+ (void)addInstanceMethod:(SEL)sel;

- (void)testRuntime_SendMsg;
- (void)testRuntime_InterceptMethods;
- (void)testRuntime_AddNewMethod;

void instanceMethod2(id self, SEL _cmd, int a);

@end

NS_ASSUME_NONNULL_END
