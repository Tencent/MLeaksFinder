//
//  UISplitViewController+MemoryLeak.m
//  MLeaksFinder
//
//  Created by zeposhe on 12/12/15.
//  Copyright © 2015 zeposhe. All rights reserved.
//

#import "UISplitViewController+MemoryLeak.h"
#import "NSObject+MemoryLeak.h"

#ifdef DEBUG

@implementation UISplitViewController (MemoryLeak)

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    
    NSArray *viewStack = [self currentViewStack];
    
    for (UIViewController *viewController in self.viewControllers) {
        [viewController setPreviousViewStack:viewStack];
        [viewController willDealloc];
    }
    
    return YES;
}

@end

#endif
