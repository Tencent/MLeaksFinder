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
#import "Aspects.h"

#if _INTERNAL_MLF_ENABLED

const void *const kHasBeenPoppedKey = &kHasBeenPoppedKey;

@implementation UIViewController (MemoryLeak)

+ (void)load {
    [UIViewController mlfAspect_hookSelector:@selector(viewWillAppear:)
                              withOptions:AspectPositionAfter
                               usingBlock:^{
                                   objc_setAssociatedObject(self, kHasBeenPoppedKey, @(NO), OBJC_ASSOCIATION_RETAIN);
                               }
                                    error:nil];

    [UIViewController mlfAspect_hookSelector:@selector(dismissViewControllerAnimated:completion:)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *viewController = (UIViewController *)aspectInfo.instance;
                                   UIViewController *dismissedViewController = viewController.presentedViewController;
                                   if (!dismissedViewController && viewController.presentingViewController) {
                                       dismissedViewController = viewController;
                                   }

                                   if (!dismissedViewController) return;
                                   
                                   [dismissedViewController willDealloc];
                               }
                                    error:nil];
}

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    
    [self willReleaseChildren:self.childViewControllers];
    [self willReleaseChild:self.presentedViewController];
    
    if (self.isViewLoaded) {
        [self willReleaseChild:self.view];
    }
    
    return YES;
}

@end

#endif
