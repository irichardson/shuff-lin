//
//  TutorialContentViewController.swift
//  blocks
//
//  Created by Ian Richardson on 8/24/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation

class TutorialContentViewController: UIPageViewController{

    @IBOutlet var titleLabel : UILabel!
    
    var pageIndex : Int = 0
    var titleText : String = ""

    override func viewWillLayoutSubviews() {
        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func viewSetup(){
        self.titleLabel = UILabel()
        self.titleLabel.text = self.titleText
    }


}