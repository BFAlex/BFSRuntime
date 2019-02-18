//
//  BFSChildren.h
//  BFSRuntime
//
//  Created by 刘玲 on 2019/2/18.
//  Copyright © 2019年 BFS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFSChildren : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;

- (void)increaseOneYear;

@end

NS_ASSUME_NONNULL_END
