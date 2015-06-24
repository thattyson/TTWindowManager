//
//  ModalViewController.swift
//  TTWindowManager Example
//
//  Created by Tyson Leslie on 2015-06-23.
//  Copyright (c) 2015 thattyson. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        TTWindowManager.sharedInstance().dismissViewControllerAtWindowPosition(.Modal)
    }
}
