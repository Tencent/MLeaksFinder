# MLeaksFinder
MLeaksFinder helps you find memory leaks in your iOS apps at develop time. It can automatically find leaks in UIView and UIViewController objects, present an alert with the leaked object in its View-ViewController stack when leaks happening. More over, it can try to find a retain cycle for the leaked object using [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector/tree/master/FBRetainCycleDetector). Besides finding leaks in UIView and UIViewController objects, developers can extend it to find leaks in other kinds of objects.

# Communication
QQ group: 482121244

# Installation
```
pod 'MLeaksFinder'
```

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

MLeaksFinder can also try to find a retain cycle for the leaked object using FBRetainCycleDetector.
```
Retain Cycle
(
    "-> MyTableViewCell ",
    "-> _callback -> __NSMallocBlock__ "
)
```
With the output, we know that the object of `MyTableViewCell` has a `__strong` instance variable named `_callback`, which is of type `__NSMallocBlock__`. And `_callback` also has a `__strong` reference back to `MyTableViewCell`.

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
