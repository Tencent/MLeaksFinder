//
//  UINavigationController+MemoryLeak.m
//  MLeaksFinder
//
//  Created by zeposhe on 12/12/15.
//  Copyright © 2015 zeposhe. All rights reserved.
//

#import "UINavigationController+MemoryLeak.h"
#import "NSObject+MemoryLeak.h"
#import <objc/runtime.h>

#if _INTERNAL_MLF_ENABLED

static const void *const kPoppedDetailVCKey = &kPoppedDetailVCKey;

@implementation UINavigationController (MemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(pushViewController:animated:) withSEL:@selector(swizzled_pushViewController:animated:)];
        [self swizzleSEL:@selector(popViewControllerAnimated:) withSEL:@selector(swizzled_popViewControllerAnimated:)];
        [self swizzleSEL:@selector(popToViewController:animated:) withSEL:@selector(swizzled_popToViewController:animated:)];
        [self swizzleSEL:@selector(popToRootViewControllerAnimated:) withSEL:@selector(swizzled_popToRootViewControllerAnimated:)];
    });
}

- (void)swizzled_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.splitViewController) {
        id detailViewController = objc_getAssociatedObject(self, kPoppedDetailVCKey);
        if ([detailViewController isKindOfClass:[UIViewController class]]) {
            [detailViewController willDealloc];
            objc_setAssociatedObject(self, kPoppedDetailVCKey, nil, OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    [self swizzled_pushViewController:viewController animated:animated];
}

- (UIViewController *)swizzled_popViewControllerAnimated:(BOOL)animated {
    UIViewController *poppedViewController = [self swizzled_popViewControllerAnimated:animated];
    
    // Navigation VC's rootViewController is the last VC in Navigation VC's viewControllers
    if (!poppedViewController) {
        return nil;
    }
    
    // Detail VC in UISplitViewController is not dealloced until another detail VC is shown
    if (self.splitViewController &&
        self.splitViewController.viewControllers.firstObject == self &&
        self.splitViewController == poppedViewController.splitViewController) {
        objc_setAssociatedObject(self, kPoppedDetailVCKey, poppedViewController, OBJC_ASSOCIATION_RETAIN);
        return poppedViewController;
    }
    
    // VC is not dealloced until disappear when popped using a left-edge swipe gesture
    extern const void *const kHasBeenPoppedKey;
    objc_setAssociatedObject(poppedViewController, kHasBeenPoppedKey, @(YES), OBJC_ASSOCIATION_RETAIN);
    
    return poppedViewController;
}

- (NSArray<UIViewController *> *)swizzled_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<UIViewController *> *poppedViewControllers = [self swizzled_popToViewController:viewController animated:animated];
    
    for (UIViewController *viewController in poppedViewControllers) {
        [viewController willDealloc];
    }
    
    return poppedViewControllers;
}

- (NSArray<UIViewController *> *)swizzled_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<UIViewController *> *poppedViewControllers = [self swizzled_popToRootViewControllerAnimated:animated];
    
    for (UIViewController *viewController in poppedViewControllers) {
        [viewController willDealloc];
    }
    
    return poppedViewControllers;
}

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    
    NSArray *viewStack = [self viewStack];
    
    for (UIViewController *viewController in self.viewControllers) {
        NSString *className = NSStringFromClass([viewController class]);
        viewStack = [viewStack arrayByAddingObject:className];
        
        [viewController setViewStack:viewStack];
        [viewController willDealloc];
    }
    
    return YES;
}

@end

#endif
