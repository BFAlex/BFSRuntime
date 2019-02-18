//
//  BFSParent.h
//  BFSRuntime
//
//  Created by 刘玲 on 2019/2/18.
//  Copyright © 2019年 BFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFSChildren.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFSParent : NSObject

@property (nonatomic, strong) BFSChildren *children;

- (void)raisingOneChildrenForName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
