//
//  NSArray.m
//  CTDebug
//
//  Created by 王腾达 on 2017/11/6.
//  Copyright © 2017年 liuweiso. All rights reserved.
//

#import "NSArray+MemoryLeak.h"
#import "MLeaksFinder.h"

#ifdef MEMORY_LEAKS_ALL_OBJECT_FINDER_ENABLED
@implementation NSArray(MemoryLeak)

- (void)willReleaseIvarList
{
    if(!self.count)
    {
        return;
    }
    
    for(id ob in self)
    {
        [ob willReleaseIvarList];
    }
}

- (BOOL)continueCheckObjecClass:(Class)objectClass
{
    return YES;
}

@end
#endif
