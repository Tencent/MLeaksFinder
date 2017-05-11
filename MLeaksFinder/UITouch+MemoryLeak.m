//
//  UITouch+MemoryLeak.m
//  MLeaksFinder
//
//  Created by 佘泽坡 on 8/31/16.
//  Copyright © 2016 zeposhe. All rights reserved.
//

#import "UITouch+MemoryLeak.h"
#import <objc/runtime.h>
#import "Aspects.h"

#if _INTERNAL_MLF_ENABLED

extern const void *const kLatestSenderKey;

@implementation UITouch (MemoryLeak)

+ (void)load {
    [UITouch mlfAspect_hookSelector:@selector(setView:)
                     withOptions:AspectPositionAfter
                      usingBlock:^(id<AspectInfo> info, UIView *view) {
                          if (view) {
                              objc_setAssociatedObject([UIApplication sharedApplication],
                                                       kLatestSenderKey,
                                                       @((uintptr_t)view),
                                                       OBJC_ASSOCIATION_RETAIN);
                          }
                      }
                           error:nil];
}

@end

#endif
