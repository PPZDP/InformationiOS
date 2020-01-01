##UIApplicationMain  and RunLoop

运行程序会先调用main方法：

###UIApplicationMain


```objectivec
int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
```
看一下苹果对 UIApplicationMain 解释
```
This function instantiates the application object from the principal class and instantiates the delegate (if any) from the given class and sets the delegate for the application. It also sets up the main event loop, including the application’s run loop, and begins processing events. If the application’s Info.plist file specifies a main nib file to be loaded, by including the NSMainNibFile key and a valid nib file name for the value, this function loads that nib file.

Despite the declared return type, this function never returns

```

通过描述，我们得知 App 启动 会：
1. 创建一个application 对象
2. 设置application的代理（AppDelegate）
3. 创建一个事件循环 (runloop)
4. 读info.plist 文件 


源码<https://opensource.apple.com/source/CF>

RunLoop<https://blog.ibireme.com/2015/05/18/runloop/>




