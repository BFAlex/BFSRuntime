//
//  BFSRuntimer.m
//  BFSRuntime
//
//  Created by 刘玲 on 2019/2/18.
//  Copyright © 2019年 BFS. All rights reserved.
//

#import "BFSRuntimer.h"
// runtime
#import <objc/runtime.h>    // 包含对类、成员变量、属性、方法的操作
#import <objc/message.h>    // 包含消息机制
#import "BFSRuntimer2.h"
#import "BFSRuntimer+test.h"


@interface BFSRuntimer() {
    int ivar1;
}
@property (nonatomic, assign) int p1;

@end

@implementation BFSRuntimer


- (void)testRuntime_AddNewMethod {
    
    class_addMethod([BFSRuntimer class], nil, (IMP)instanceNewMethod, "@:");
    [self performSelector:@selector(instanceNewMethod) withObject:nil afterDelay:1.0f];
    
}

void instanceNewMethod()
{
    printf("?????instanceNewMethod");
}

- (void)testRuntime_InterceptMethods {
    // instance method
    [self performSelector:@selector(instanceMethod) withObject:nil afterDelay:1.f];
}

void instanceMethod2(id self, SEL _cmd, int a)
{
    NSLog(@"instanceMethod2");
    NSLog(@"【%@】%@:%d", NSStringFromClass([self class]), NSStringFromSelector(_cmd), a);
    
}

void instanceMethod3(id self, SEL _cmd, NSString *a)
{
    NSLog(@"instanceMethod3");
    NSLog(@"【%@】%@:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), a);
    
}

+ (void)addInstanceMethod:(SEL)sel {
    
    if ([NSStringFromSelector(sel) isEqualToString:@"instanceMethod"]) {
        class_addMethod(self, sel, (IMP)instanceMethod2, "MT");
        // 属性关联
        const void *propertykey;
        objc_setAssociatedObject(self, propertykey, @"关联的新属性", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSString *associateProperty = objc_getAssociatedObject(self, propertykey);
        NSLog(@"打印关联属性的获取结果：%@", associateProperty);
        BFSRuntimer *rt = [[self alloc] init];
        [rt testRuntime_SendMsg];
        if (rt) {
            size_t size = class_getInstanceSize(rt);
            NSLog(@"instance size: %zu", size);
        }
    }
}

#pragma mark - Runtime method

+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), NSStringFromSelector(sel));
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), NSStringFromSelector(sel));
    // 动态添加方法
    //    [self addInstanceMethod:sel];
    
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), NSStringFromSelector(aSelector));
//    if ([NSStringFromSelector(aSelector) isEqualToString:@"instanceMethod"]) {
//        return [[BFSRuntimer2 alloc] init];
//    }
    
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%@, %@", NSStringFromSelector(_cmd), NSStringFromSelector(aSelector));
    if ([NSStringFromSelector(aSelector) isEqualToString:@"instanceMethod"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

// 收集漂流瓶的港口？
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%@, %@", NSStringFromSelector(_cmd), anInvocation);
    
    SEL sel = anInvocation.selector;
    BFSRuntimer2 *otherObj = [[BFSRuntimer2 alloc] init];
    if ([otherObj respondsToSelector:sel]) {
        NSLog(@"漂流瓶找到执行者了：%@", NSStringFromSelector(sel));
    }
}

#pragma mark - Runtime的应用
#pragma mark

#pragma mark - API

- (void)testAssociateUsage {
    [self setObjSpecialName:@"AssocaiteUasge Test"];
    NSString *result = [self objSpecialName];
    NSLog(@"Category Assocaitive Usage: %@", result);
}
// 添加类方法
- (void)testClassAddMethod {
    // instanceMethod2
    SEL selector = @selector(instanceMethod3);
//    class_getMethodImplementation(<#Class  _Nullable __unsafe_unretained cls#>, <#SEL  _Nonnull name#>)
//    method_getImplementation(<#Method  _Nonnull m#>)
    BOOL result = class_addMethod([self class], selector, (IMP)instanceMethod3, "v@:");
    if (result) {
        [self performSelector:@selector(instanceMethod3) withObject:@"ClassAddMethod" afterDelay:0];
    }
}

- (void)testReplaceMehtods {
    NSLog(@"before replace");
    [self method1];
    [self method2];
    [self startReplaceMethods];
    NSLog(@"after replace");
    [self method1];
    [self method2];
}
- (void)startReplaceMethods {
    
    SEL sel1 = @selector(method1);
    SEL sel2 = @selector(method2);
    Method method1 = class_getClassMethod([self class], sel1);
    Method method2 = class_getClassMethod([self class], sel2);
    IMP imp1 = method_getImplementation(method1);
    IMP imp2 = method_getImplementation(method2);
    class_replaceMethod([self class], sel2, imp1, method_getTypeEncoding(method1));
    method_exchangeImplementations(method1, method2);  
    
}

- (void)method1 {
    NSLog(@"111%@", NSStringFromSelector(_cmd));
}
- (void)method2 {
    NSLog(@"222%@", NSStringFromSelector(_cmd));
}

- (void)testInfo {
    
}

- (void)testRuntime_SendMsg {
    
    unsigned int ivarCount;
    Ivar *ivars = class_copyIvarList([self class], &ivarCount);
    NSLog(@"ivars number: %d", ivarCount);
    for (int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"ivar name(%d):%s", i, ivar_getName(ivar));
    }
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    NSLog(@"property number: %d", propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property name(%d):%s", i, property_getName(property));
    }
    //
    SEL selName = @selector(method2:andparam:);
    Method method = class_getInstanceMethod([self class], selName);
    NSLog(@"SEL name: %s", sel_getName(selName));
    //
    
}

- (void)rtTestMsg {
    NSLog(@"runtime test message.");
}

- (void)method2:(NSString *)arg1 andparam:(NSString *)arg2 {
    
}

@end
