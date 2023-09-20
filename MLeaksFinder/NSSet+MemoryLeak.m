//
//  NSSet.m
//  CTDebug
//
//  Created by 王腾达 on 2017/11/6.
//  Copyright © 2017年 liuweiso. All rights reserved.
//

#import "NSSet+MemoryLeak.h"
#import "MLeaksFinder.h"

#ifdef MEMORY_LEAKS_ALL_OBJECT_FINDER_ENABLED
@implementation NSSet(MemoryLeak)

- (void)willReleaseIvarList
{
    if(!self.count)
    {
        return;
    }
    
    id obj;
    
    NSEnumerator * enumerator = [self objectEnumerator];
    while (obj = [enumerator nextObject]) {
        [obj willReleaseIvarList];
    }
}

- (BOOL)continueCheckObjecClass:(Class)objectClass
{
    return YES;
}

@end
#endif
