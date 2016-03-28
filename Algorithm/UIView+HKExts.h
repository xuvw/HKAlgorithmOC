//
//  UIView+HKExts.h
//  HKAlgorithmOC
//
//  Created by heke on 16/3/29.
//  Copyright © 2016年 mhk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HKExts)

@property (nonatomic, assign) BOOL visited;

- (UIView *)subViewOfClass:(NSString *)aClassName;

@end
