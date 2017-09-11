[中文介绍](http://wereadteam.github.io/2016/07/20/MLeaksFinder2/) | [FAQ中文](https://github.com/Zepo/MLeaksFinder/blob/master/FAQ-CN.md)

# MLeaksFinder
MLeaksFinder helps you find memory leaks in your iOS apps at develop time. It can automatically find leaks in UIView and UIViewController objects, present an alert with the leaked object in its View-ViewController stack when leaks happening. ~~More over, it can try to find a retain cycle for the leaked object using [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector/tree/master/FBRetainCycleDetector).~~ Besides finding leaks in UIView and UIViewController objects, developers can extend it to find leaks in other kinds of objects.

# Communication
QQ group: 482121244

# Installation
```
pod 'MLeaksFinder'
```
MLeaksFinder comes into effect after `pod install`, there is no need to add any code nor to import any header file.

*WARNING: FBRetainCycleDetector is removed from the podspec due to Facebook's BSD-plus-Patents license. If you want to use FBRetainCycleDetector to find retain cycle, add `pod 'FBRetainCycleDetector'` to your project's Podfile and turn the macro `MEMORY_LEAKS_FINDER_RETAIN_CYCLE_ENABLED` on in `MLeaksFinder.h`.*

# Usage
MLeaksFinder can automatically find leaks in UIView and UIViewController objects. When leaks happening, it will present an alert with the leaked object in its View-ViewController stack.
```
Memory Leak
(
    MyTableViewController,
    UITableView,
    UITableViewWrapperView,
    MyTableViewCell
)
```

For the above example, we are sure that objects of `MyTableViewController`, `UITableView`, `UITableViewWrapperView` are deallocated successfully, but not the objects of `MyTableViewCell`.

## Mute Assertion
If your class is designed as singleton or for some reason objects of your class should not be dealloced, override `- (BOOL)willDealloc` in your class by returning NO.
```objc
- (BOOL)willDealloc {
    return NO;
}
```

## Find Leaks in Other Objects
MLeaksFinder finds leaks in UIView and UIViewController objects by default. However, you can extend it to find leaks in the whole object graph rooted at a UIViewController object.
```objc
- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    
    MLCheck(self.viewModel);
    return YES;
}
```
