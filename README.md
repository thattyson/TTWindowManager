# TTWindowManager
A simple window presentation manager for iOS written in objective-c which takes advantage of `UIWindow`

> I wrote TTWindowManager before swift existed. 
> I haven't converted it but have now fully embraced swift so I'm exclusively showing swift implementation.
> Add `#import TTWindowManager.h` to your bridging header and code away!


### Implementation (swift)

Override the main `UIWindow` in your AppDelegate with a `TTWindow` to take full advantage of the stack.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow?
    //Replace default with TTWindow override
    var window : UIWindow? = {
        let window = TTWindow()
        return window
        } ()
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        //Important to ensure the window is properly sized
        self.window?.frame = UIScreen.mainScreen().bounds
        return true
    }
}
```

Add a shake gesture callback to display a debug console or something else app-specific

> Add it to `didFinishLaunchingWithOptions` in your AppDelegate if you're overriding the default UIWindow

```swift
(self.window as! TTWindow).shakeGestureCallback = { () -> Void in
    //Display something on shake
    println("Shake!")
}
```


Quickly present a new TTWindow with an animation and at a specific window level
```swift
TTWindowManager.sharedInstance().presentViewController(viewController, atWindowPosition: .Modal, withAnimation: .Modal) { (success) -> Void in
            
}
```

> `TTWindowPosition` determines what z-index the TTWindow will present.
> These values are based around `UIWindowLevel` and will present the window above or behind native Apple components like the `UIStatusBar` or `UIAlert`s

# License & Credits

`TTWindowManager` is published under the MIT license.
It has been created and developped by me (thattyson)