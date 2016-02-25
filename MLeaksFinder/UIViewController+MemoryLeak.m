//
//  UIViewController+MemoryLeak.m
//  MLeaksFinder
//
//  Created by zeposhe on 12/12/15.
//  Copyright © 2015 zeposhe. All rights reserved.
//

#import "UIViewController+MemoryLeak.h"
#import "NSObject+MemoryLeak.h"
#import <objc/runtime.h>

#ifdef DEBUG

@implementation UIViewController (MemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(dismissViewControllerAnimated:completion:) withSEL:@selector(swizzled_dismissViewControllerAnimated:completion:)];
    });
}

- (void)swizzled_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self swizzled_dismissViewControllerAnimated:flag completion:completion];
    
    UIViewController *dismissedViewController = self.presentedViewController;
    if (!dismissedViewController && self.presentingViewController) {
        dismissedViewController = self;
    }
    
    if (!dismissedViewController) return;
    
    [dismissedViewController willDealloc];
}

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    
    NSArray *viewStack = [self viewStack];
    
    UIViewController *presentedViewController = self.presentedViewController;
    if (presentedViewController) {
        NSString *className = NSStringFromClass([presentedViewController class]);
        [presentedViewController setViewStack:[viewStack arrayByAddingObject:className]];
        [presentedViewController willDealloc];
    }
    
    NSString *className = NSStringFromClass([self.view class]);
    [self.view setViewStack:[viewStack arrayByAddingObject:className]];
    [self.view willDealloc];
    
    return YES;
}

@end

#endif
