# MLeaksFinder
MLeaksFinder helps you find memory leaks in your iOS and OS X apps at develop time. It can automatically find leaks in UIView and UIViewController objects, hit assertion and print the View-ViewController stack when leaks happening. You can also extend it to find leaks in other kinds of objects.

# Installation
- Download MLeaksFinder
- Add MLeaksFinder as a subproject
- Add MLeaksFinder to your Target Dependencies and Link Binary With Libraries

# Usage
MLeaksFinder can automatically find leaks in UIView and UIViewController objects. When leaks happening, it will hit assertion and print the leaked object in its View-ViewController stack.
```
*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Possibly Memory Leak.
In case that MyTableViewCell should not be dealloced, override -assertNotDealloc in MyTableViewCell by giving it an empty implementation.
View-ViewController stack: (
    MyTableViewController,
    UITableView,
    UITableViewWrapperView,
    MyTableViewCell
)'
```
## Mute Assertion
If your class is designed as singleton or for some reason objects of your class should not be dealloc, override -assertNotDealloc in your class by giving it an empty implementation.
```
- (void)assertNotDealloc {
    
}
```
## Find Leaks in Other Objects
```
- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    
    [self.viewModel willDealloc];
    return YES;
}
```
