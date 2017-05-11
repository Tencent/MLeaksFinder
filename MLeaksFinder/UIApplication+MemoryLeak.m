//
//  UIApplication+MemoryLeak.m
//  MLeaksFinder
//
//  Created by 佘泽坡 on 5/11/16.
//  Copyright © 2016 zeposhe. All rights reserved.
//

#import "UIApplication+MemoryLeak.h"
#import "NSObject+MemoryLeak.h"
#import <objc/runtime.h>
#import "Aspects.h"

#if _INTERNAL_MLF_ENABLED

extern const void *const kLatestSenderKey;

@implementation UIApplication (MemoryLeak)

+ (void)load {
    [UIApplication mlfAspect_hookSelector:@selector(sendAction:to:from:forEvent:)
                           withOptions:AspectPositionBefore
                            usingBlock:^(id<AspectInfo> aspectInfo, SEL action, id target, id sender, UIEvent *event) {
                                UIApplication *application = (UIApplication *)aspectInfo.instance;
                                objc_setAssociatedObject(application, kLatestSenderKey, @((uintptr_t)sender), OBJC_ASSOCIATION_RETAIN);
                            }
                                 error:nil];
}

@end

#endif
