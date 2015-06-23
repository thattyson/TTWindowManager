//
//  AppDelegate.swift
//  TTWindowManager Example
//
//  Created by Tyson Leslie on 2015-06-23.
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
        
        //Important to ensure the window is properly sized
        self.window?.frame = UIScreen.mainScreen().bounds
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        (self.window as! TTWindow).shakeGestureCallback = { () -> Void in
            //Display something on shake
            println("Shake!")
        }
        return true
    }
}

