//
//  UITabBarController+MemoryLeak.m
//  MLeaksFinder
//
//  Created by zeposhe on 12/12/15.
//  Copyright © 2015 zeposhe. All rights reserved.
//

#import "UITabBarController+MemoryLeak.h"
#import "NSObject+MemoryLeak.h"

#if _INTERNAL_MLF_ENABLED

@implementation UITabBarController (MemoryLeak)

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    
    NSArray *viewStack = [self viewStack];
    
    for (UIViewController *viewController in self.viewControllers) {
        NSString *className = NSStringFromClass([viewController class]);
        [viewController setViewStack:[viewStack arrayByAddingObject:className]];
        [viewController willDealloc];
    }
    
    return YES;
}

@end

#endif
