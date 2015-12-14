//
//  UIView+MemoryLeak.m
//  MLeaksFinder
//
//  Created by zeposhe on 12/12/15.
//  Copyright © 2015 zeposhe. All rights reserved.
//

#import "UIView+MemoryLeak.h"
#import "NSObject+MemoryLeak.h"

#ifdef DEBUG

@implementation UIView (MemoryLeak)

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    
    NSArray *viewStack = [self currentViewStack];
    
    for (UIView *view in self.subviews) {
        [view setPreviousViewStack:viewStack];
        [view willDealloc];
    }
    
    return YES;
}

@end

#endif
