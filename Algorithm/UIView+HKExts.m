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

@end

@implementation NSMutableArray (HKExtsStack)



@end

@implementation UIView (HKExts)

/*
 BFS
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
    
    while (![queue isQueueEmpty]) {
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
    
    return targetView;
}

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
