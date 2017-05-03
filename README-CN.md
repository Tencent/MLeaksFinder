# FAQ
**1) 引进 MLeaksFinder 后没生效？**

* 先验证引进是否正确，在 UIViewController+MemoryLeak.m 的 `+ (void)load` 方法里加断点，app 启动时进入该方法则引进成功，否则引进失败。
* 用 CocoaPods 安装时注意有没有 warnings，特别是 `OTHER_LDFLAGS` 相关的 warnings。如果有 warnings，可以在主工程的 Build Settings -> Other Linker Flags 加上 `-ObjC`。

**2) 可以手动引进 MLeaksFinder 吗？**

* 直接把 MLeaksFinder 的代码放到项目里即生效。如果把 MLeaksFinder 做为子工程，需要在主工程的 Build Settings -> Other Linker Flags 加上 `-ObjC`。
* 引进 MLeaksFinder 的代码后即可检测内存泄漏，但查找循环引用的功能还未生效。可以再手动加入 FBRetainCycleDetector 代码，然后把 MLeaksFinder.h 里的 `//#define MEMORY_LEAKS_FINDER_RETAIN_CYCLE_ENABLED 1` 打开。

**3) Fail to find a retain cycle？**

* 内存泄漏不一定是循环引用造成的。
* 有的循环引用 FBRetainCycleDetector 不一定能找出。

**4) 如何关掉 MLeaksFinder？**

* MLeaksFinder 默认只在 debug 下生效，当然也可以通过 MLeaksFinder.h 里的 `//#define MEMORY_LEAKS_FINDER_ENABLED 0` 来手动控制开关。
