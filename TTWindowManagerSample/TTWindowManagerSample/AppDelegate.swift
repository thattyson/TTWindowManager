//
//  AppDelegate.swift
//  TTWindowManagerSample
//
//  Created by Tyson Leslie on 2015-06-24.
//  Copyright (c) 2015 thattyson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow?
    //Replace default with TTWindow override
    var window : UIWindow? = {
        let window = TTWindow()
        return window
        } ()
    
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        //Important to ensure the window is properly sized on launch
        self.window?.frame = UIScreen.mainScreen().bounds
        self.window?.backgroundColor = UIColor.purpleColor()
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        (self.window as! TTWindow).shakeGestureCallback = { () -> Void in
            
            //Display something on shake
            println("Shake!")
        }
        
        
        //This is fired whenever you pause the debugger and will only ever be called in DEBUG builds
        TTWindowManager.sharedInstance().debuggerPauseCallback = { () -> Void in
            
            //Print important info to the console or add a breakpoint here and read any values you need
            println("Hi, I am: \(self.debugDescription)")
        }
        
        return true
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        
        if let ttWindow = window as? TTWindow {
            return Int(ttWindow.supportedOrientation.rawValue)
        }
        
        return Int(UIInterfaceOrientationMask.All.rawValue);
    }
}

