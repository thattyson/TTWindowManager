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

    @IBAction func showWindowButtonTapped(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController! = storyboard.instantiateViewControllerWithIdentifier("ModalViewController") as! UIViewController
        
        TTWindowManager.sharedInstance().presentViewController(viewController, atWindowPosition: .Modal, withAnimation: .Modal) { (success) -> Void in
            
        }
    }
}

