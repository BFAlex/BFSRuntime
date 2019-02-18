//
//  BFSParent.m
//  BFSRuntime
//
//  Created by 刘玲 on 2019/2/18.
//  Copyright © 2019年 BFS. All rights reserved.
//

#import "BFSParent.h"

@implementation BFSParent

- (void)raisingOneChildrenForName:(NSString *)name {
    
    self.children = [[BFSChildren alloc] init];
    self.children.name = [name copy];
    self.children.age = 1;
    [self.children addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    BFSChildren *children = (BFSChildren *)object;
    NSLog(@"%@消息有新的消息：属性(%@)发生更改为：%d", children.name, keyPath, children.age);
}

@end
