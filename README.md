# MLeaksFinder
MLeaksFinder helps you find memory leaks in your iOS apps at develop time. It can automatically find leaks in UIView and UIViewController objects, hit assertion and print the View-ViewController stack when leaks happening. You can also extend it to find leaks in other kinds of objects.

# Communication
QQ group: 482121244

# Installation
- Download MLeaksFinder
- Add MLeaksFinder as a subproject
- Add MLeaksFinder to your Target Dependencies and Link Binary With Libraries
- Click your app's target, then "Build Settings", search for "Other Linker Flags", add '-ObjC'

Or you can simply copy the source files into your project.

## Installation with CocoaPods
```
pod 'MLeaksFinder'
```

# Usage
MLeaksFinder can automatically find leaks in UIView and UIViewController objects. When leaks happening, it will hit assertion and print the leaked object in its View-ViewController stack.
```
*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Possibly Memory Leak.
In case that MyTableViewCell should not be dealloced, override -willDealloc in MyTableViewCell by returning NO.
View-ViewController stack: (
    MyTableViewController,
    UITableView,
    UITableViewWrapperView,
    MyTableViewCell
)'
```

## Mute Assertion
If your class is designed as singleton or for some reason objects of your class should not be dealloced, override -willDealloc in your class by returning NO.
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
