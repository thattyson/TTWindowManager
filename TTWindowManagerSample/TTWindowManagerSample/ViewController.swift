//
//  ViewController.swift
//  TTWindowManager Example
//
//  Created by Tyson Leslie on 2015-06-23.
//  Copyright (c) 2015 thattyson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func scaleWindowButtonTapped(sender: AnyObject) {
        presentWindowWithAnimation(.ScaleDown)
    }
    
    @IBAction func modalWindowButtonTapped(sender: AnyObject) {
        presentWindowWithAnimation(.Modal)
    }
    
    @IBAction func fadeWindowButtonTapped(sender: AnyObject) {
        presentWindowWithAnimation(.Fade)
    }
    
    private func presentWindowWithAnimation(animation : TTWindowAnimationType) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController! = storyboard.instantiateViewControllerWithIdentifier("ModalViewController") as! UIViewController
        
        TTWindowManager.sharedInstance().presentViewController(viewController, atWindowPosition: .Modal, withAnimation: animation) { (success) -> Void in
            
        }
    }
}

