//
//  NSDictionary.m
//  CTDebug
//
//  Created by 王腾达 on 2017/11/6.
//  Copyright © 2017年 liuweiso. All rights reserved.
//

#import "NSDictionary+MemoryLeak.h"
#import "MLeaksFinder.h"

#ifdef MEMORY_LEAKS_ALL_OBJECT_FINDER_ENABLED
@implementation NSDictionary(MemoryLeak)

- (void)willReleaseIvarList
{
    if(!self.count)
    {
        return;
    }
    
    for(id ob in self.allValues)
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
