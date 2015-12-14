//
//  UIViewController+MemoryLeak.m
//  MLeaksFinder
//
//  Created by zeposhe on 12/12/15.
//  Copyright © 2015 zeposhe. All rights reserved.
//

#import "UIViewController+MemoryLeak.h"
#import "NSObject+MemoryLeak.h"

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
    
    NSArray *viewStack = [self currentViewStack];
    
    UIViewController *presentedViewController = self.presentedViewController;
    if (presentedViewController) {
        [presentedViewController setPreviousViewStack:viewStack];
        [presentedViewController willDealloc];
    }
    
    [self.view setPreviousViewStack:viewStack];
    [self.view willDealloc];
    
    return YES;
}

@end

#endif
