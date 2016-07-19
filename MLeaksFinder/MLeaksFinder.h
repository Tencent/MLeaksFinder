//
//  MLeaksFinder.h
//  MLeaksFinder
//
//  Created by zeposhe on 12/12/15.
//  Copyright © 2015 zeposhe. All rights reserved.
//

#import "NSObject+MemoryLeak.h"

//#define MEMORY_LEAKS_FINDER_ENABLED 0

#ifdef MEMORY_LEAKS_FINDER_ENABLED
#define _INTERNAL_MLF_ENABLED MEMORY_LEAKS_FINDER_ENABLED
#else
#define _INTERNAL_MLF_ENABLED DEBUG
#endif

//#define RETAIN_CYCLE_DETECTOR_ENABLED 0

#ifdef RETAIN_CYCLE_DETECTOR_ENABLED
#define _INTERNAL_RCD_ENABLED RETAIN_CYCLE_DETECTOR_ENABLED
#elif COCOAPODS
#define _INTERNAL_RCD_ENABLED COCOAPODS
#endif
