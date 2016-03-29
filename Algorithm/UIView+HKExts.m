//
//  UIView+HKExts.m
//  HKAlgorithmOC
//
//  Created by heke on 16/3/29.
//  Copyright © 2016年 mhk. All rights reserved.
//

#import "UIView+HKExts.h"
#import <objc/runtime.h>

@interface NSMutableArray (HKExtsQueue)

- (void)clearQueue;
- (BOOL)isQueueEmpty;
- (void)enterQueue:(id)item;//rear
- (id)deQueue;//front
- (id)rearItem;
- (id)frontItem;
- (NSInteger)queueLength;

@end

@implementation NSMutableArray (HKExtsQueue)

- (void)clearQueue {
    [self removeAllObjects];
}

- (BOOL)isQueueEmpty {
    return [self count]<1;
}
- (void)enterQueue:(id)item {
    [self addObject:item];
}//rear
- (id)deQueue {
    id item = [self firstObject];
    [self removeObject:item];
    return item;
}//front
- (id)rearItem {
    return [self lastObject];
}
- (id)frontItem {
    return [self firstObject];
}
- (NSInteger)queueLength {
    return [self count];
}

@end

@interface NSMutableArray (HKExtsStack)

- (void)clearStack;
- (BOOL)isStackEmpty;
- (NSInteger)stackLength;

- (void)push:(id)item;
- (id)popItem;
- (id)topItem;
- (id)bottomItem;

@end

@implementation NSMutableArray (HKExtsStack)

- (void)clearStack {
    [self removeAllObjects];
}
- (BOOL)isStackEmpty {
    return [self count]<1;
}
- (NSInteger)stackLength {
    return [self count];
}

- (void)push:(id)item {
    [self addObject:item];
}
- (id)popItem {
    id item = [self lastObject];
    [self removeLastObject];
    return item;
}
- (id)topItem {
    return [self lastObject];
}
- (id)bottomItem {
    return [self firstObject];
}

@end

@implementation UIView (HKExts)

/*
 BFS
 2016-03-29 10:32:24.425 HKAlgorithmOC[60735:660819] search time :6
 2016-03-29 10:32:24.426 HKAlgorithmOC[60735:660819] search time :7
 */
- (UIView *)subViewOfClass:(NSString *)aClassName {
    
    if (aClassName.length<1) {
        return nil;
    }
    
    Class class = NSClassFromString(aClassName);
    __block UIView *targetView = nil;
    
    NSMutableArray *visitedViews = [NSMutableArray array];
    NSMutableArray *queue = [NSMutableArray array];
    [queue enterQueue:self];
    
    __block NSArray *subViews = nil;
    __block UIView  *aView = nil;
    NSInteger count = 0;
    while (![queue isQueueEmpty]) {
        count++;
        aView = [queue frontItem];
        subViews = [aView subviews];
        aView = nil;
        [subViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull aSubView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!aSubView.visited) {
                aView = aSubView;
                *stop = YES;
            }
        }];
        
        if (aView) {
            if ([aView isKindOfClass:class]) {
                targetView = aView; break;
            }else{
                aView.visited = YES;
                [queue enterQueue:aView];
            }
        }else{
            [visitedViews addObject:[queue deQueue]];
        }
    }
    
    [visitedViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull aSubView, NSUInteger idx, BOOL * _Nonnull stop) {
        aSubView.visited = NO;
    }];
    
    [visitedViews removeAllObjects];
    
    [queue enumerateObjectsUsingBlock:^(UIView *  _Nonnull aSubView, NSUInteger idx, BOOL * _Nonnull stop) {
        aSubView.visited = NO;
    }];
    
    [queue clearQueue];
    
    NSLog(@"search time :%ld",count);
    return targetView;
}

/*
 DFS
 2016-03-29 10:31:10.960 HKAlgorithmOC[60713:660098] search time :8
 2016-03-29 10:31:10.960 HKAlgorithmOC[60713:660098] search time :10
 */
//- (UIView *)subViewOfClass:(NSString *)aClassName {
//    
//    if (aClassName.length<1) {
//        return nil;
//    }
//    
//    Class class = NSClassFromString(aClassName);
//    __block UIView *targetView = nil;
//    
//    NSMutableArray *visitedViews = [NSMutableArray array];
//    NSMutableArray *stack = [NSMutableArray array];
//    __block NSArray *subViews = nil;
//    __block UIView  *aView    = nil;
//    
//    self.visited = YES;
//    [stack push:self];
//    NSInteger count = 0;
//    while (![stack isStackEmpty]) {
//        count ++;
//        aView = [stack topItem];
//        subViews = [aView subviews];
//        aView = nil;
//        [subViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull aSubView, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (!aSubView.visited) {
//                aView = aSubView; *stop = YES;
//            }
//        }];
//        
//        if (aView) {
//            if ([aView isKindOfClass:class]) {
//                targetView = aView;
//                break;
//            }else{
//                aView.visited = YES;
//                [stack push:aView];
//            }
//        }else{
//            [visitedViews addObject:[stack popItem]];
//        }
//    }
//    
//    [visitedViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull aSubView, NSUInteger idx, BOOL * _Nonnull stop) {
//        aSubView.visited = NO;
//    }];
//    
//    [stack enumerateObjectsUsingBlock:^(UIView *  _Nonnull aSubView, NSUInteger idx, BOOL * _Nonnull stop) {
//        aSubView.visited = NO;
//    }];
//    
//    [visitedViews removeAllObjects]; [stack removeAllObjects];
//    
//    NSLog(@"search time :%ld",count);
//    return targetView;
//}

#pragma mark - private
- (void)setVisited:(BOOL)visited {
    objc_setAssociatedObject(self, _cmd, [NSNumber numberWithBool:visited], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)visited {
    NSNumber *temp = objc_getAssociatedObject(self, @selector(setVisited:));
    if (!temp) {
        return NO;
    }
    return [temp boolValue];
}

@end
