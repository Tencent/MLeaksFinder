[中文介绍](http://wereadteam.github.io/2016/07/20/MLeaksFinder2/) | [FAQ中文](https://github.com/Zepo/MLeaksFinder/blob/master/FAQ-CN.md)

# MLeaksFinder下架停运公告
尊敬的开发者：
您好。我们将/已于2023年09月08日0时0分下架并停止MLeaksFinder SDK服务。自2023年09月08日0时0分起，停止MLeaksFinder SDK所有代码维护服务，并删除数据。为避免影响您的产品功能及开发体验，建议您尽快在应用产品中移除下架版本SDK代码。届时我们将依据法律规定及合同约定处理终端用户个人信息。
为了更好的支持开发者对于MLeaksFinder的需求，我们也提供了更为专业全面的SDK产品，如您有相关需求，可通过客服（mleaksfinder@tencent.com）咨询，我们将竭诚为您服务。
感谢长期以来对MLeaksFinder SDK的信赖和支持！


广州腾讯科技有限公司
2023年08月31日


---

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
