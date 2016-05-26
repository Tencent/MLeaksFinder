//
//  NSObject+MemoryLeak.h
//  MLeaksFinder
//
//  Created by zeposhe on 12/12/15.
//  Copyright © 2015 zeposhe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MLCheck(TARGET) [self willReleaseObject:(TARGET) relationship:@#TARGET];

@interface NSObject (MemoryLeak)

- (BOOL)willDealloc;
- (void)willReleaseObject:(id)object relationship:(NSString *)relationship;

- (NSArray *)viewStack;
- (void)setViewStack:(NSArray *)viewStack;

#ifdef USE_MLEAKSFINDER

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL;

#endif

@end
