//
//  ModalViewController.swift
//  TTWindowManager Example
//
//  Created by Tyson Leslie on 2015-06-23.
//  Copyright (c) 2015 thattyson. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    private static let kColorSelection = "kColorSelection"
    
    @IBOutlet weak var colorSegementedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let selectedColor = NSUserDefaults.standardUserDefaults().integerForKey(ModalViewController.kColorSelection)
        updateBackgroundColorForSelection(selectedColor)
        
        self.colorSegementedControl.selectedSegmentIndex = selectedColor
    }
    

    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        TTWindowManager.sharedInstance().dismissTopWindowWithCompletion(nil);
    }
    
    @IBAction func colorControllerChanged(sender: UISegmentedControl) {
        
        updateBackgroundColorForSelection(sender.selectedSegmentIndex)
    }
    
    private func updateBackgroundColorForSelection(selection : Int) {
        
        switch selection {
        case 0 :
            TTWindowManager.sharedInstance().setBackgroundColor(UIColor.whiteColor())
        case 1 :
            TTWindowManager.sharedInstance().setBackgroundColor(UIColor.blackColor())
        case 2 :
            TTWindowManager.sharedInstance().setBackgroundColor(UIColor.purpleColor())
        case 3 :
            TTWindowManager.sharedInstance().setBackgroundImage(UIImage(named: "tie dye"))
            
        default : ()
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(selection, forKey: ModalViewController.kColorSelection)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}
