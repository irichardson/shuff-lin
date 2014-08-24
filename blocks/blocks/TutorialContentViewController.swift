//
//  TutorialContentViewController.swift
//  blocks
//
//  Created by Ian Richardson on 8/24/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation

class TutorialContentViewController: UIPageViewController{

    @IBOutlet var image : UIImageView!
    
    var pageIndex : Int = 0
    var imageName : String = ""

    override func viewWillLayoutSubviews() {
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
    }
    
    
    func viewSetup(){
        self.image = UIImageView()
        self.image = UIImageView(image: UIImage(contentsOfFile: imageName))
        
        self.image.frame = CGRectMake(self.view.frame.width/2, self.view.frame.height/2, self.image.frame.width, self.image.frame.height)
        self.view.addSubview(self.image)
    }

}