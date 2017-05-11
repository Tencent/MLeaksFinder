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
#import "Aspects.h"

#if _INTERNAL_MLF_ENABLED

static const void *const kPoppedDetailVCKey = &kPoppedDetailVCKey;

@implementation UINavigationController (MemoryLeak)

+ (void)load {
    [UINavigationController mlfAspect_hookSelector:@selector(pushViewController:animated:)
                                    withOptions:AspectPositionBefore
                                     usingBlock:^(id<AspectInfo> aspectInfo) {
                                         UINavigationController *navigationController = (UINavigationController *)aspectInfo.instance;
                                         if (navigationController.splitViewController) {
                                             id detailViewController = objc_getAssociatedObject(self, kPoppedDetailVCKey);
                                             if ([detailViewController isKindOfClass:[UIViewController class]]) {
                                                 [detailViewController willDealloc];
                                                 objc_setAssociatedObject(self, kPoppedDetailVCKey, nil, OBJC_ASSOCIATION_RETAIN);
                                             }
                                         }
                                     }
                                          error:nil];

    [UINavigationController mlfAspect_hookSelector:@selector(popViewControllerAnimated:)
                                    withOptions:AspectPositionInstead
                                     usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
                                         [aspectInfo.originalInvocation setArgument:&animated atIndex:2];
                                         [aspectInfo.originalInvocation invoke];
                                         UIViewController *poppedViewController;
                                         [aspectInfo.originalInvocation getReturnValue:&poppedViewController];

                                         if (poppedViewController) {
                                             UINavigationController *navigationController = (UINavigationController *)aspectInfo.instance;
                                             // Detail VC in UISplitViewController is not dealloced until another detail VC is shown
                                             if (navigationController.splitViewController &&
                                                 navigationController.splitViewController.viewControllers.firstObject == navigationController &&
                                                 navigationController.splitViewController == poppedViewController.splitViewController) {
                                                 objc_setAssociatedObject(navigationController, kPoppedDetailVCKey, poppedViewController, OBJC_ASSOCIATION_RETAIN);
                                             }
                                             else {
                                                 // VC is not deallocated until disappear when popped using a left-edge swipe gesture
                                                 extern const void *const kHasBeenPoppedKey;
                                                 objc_setAssociatedObject(poppedViewController, kHasBeenPoppedKey, @(YES), OBJC_ASSOCIATION_RETAIN);
                                             }
                                         }
                                     }
                                          error:nil];

    [UINavigationController mlfAspect_hookSelector:@selector(popToViewController:animated:)
                                    withOptions:AspectPositionAfter
                                     usingBlock:^(id<AspectInfo> aspectInfo) {
                                         NSArray<UIViewController *> *poppedViewControllers;
                                         [aspectInfo.originalInvocation getReturnValue:&poppedViewControllers];
                                         for (UIViewController *viewController in poppedViewControllers) {
                                             [viewController willDealloc];
                                         }
                                     }
                                          error:nil];

    [UINavigationController mlfAspect_hookSelector:@selector(popToRootViewControllerAnimated:)
                                    withOptions:AspectPositionAfter
                                     usingBlock:^(id<AspectInfo> aspectInfo) {
                                         NSArray<UIViewController *> *poppedViewControllers;
                                         [aspectInfo.originalInvocation getReturnValue:&poppedViewControllers];
                                         for (UIViewController *viewController in poppedViewControllers) {
                                             [viewController willDealloc];
                                         }
                                     }
                                          error:nil];
}

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    
    [self willReleaseChildren:self.viewControllers];
    
    return YES;
}

@end

#endif
