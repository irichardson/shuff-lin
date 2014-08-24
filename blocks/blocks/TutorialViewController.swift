//
//  TutorialViewController.swift
//  blocks
//
//  Created by Ian Richardson on 8/24/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIPageViewController{

    var close: UIButton = UIButton()

    override func viewWillLayoutSubviews() {
        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        
        close = UIButton.buttonWithType(UIButtonType.System) as UIButton
        close.frame = CGRectMake(100, 100, 100, 50)
        close.backgroundColor = UIColor.greenColor()
        close.setTitle("Close", forState: UIControlState.Normal)
        close.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(close)
    }
    
    func close(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}