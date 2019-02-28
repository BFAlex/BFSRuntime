//
//  BFSRuntimer+test.m
//  BFSRuntime
//
//  Created by 刘玲 on 2019/2/28.
//  Copyright © 2019年 BFS. All rights reserved.
//

#import "BFSRuntimer+test.h"
#import "objc/runtime.h"

@implementation BFSRuntimer (test)

static char snKey;

- (void)setObjSpecialName:(NSString *)name {
    objc_setAssociatedObject(self, &snKey, name, OBJC_ASSOCIATION_COPY);
}

- (NSString *)objSpecialName {
    return objc_getAssociatedObject(self, &snKey);
}


@end
