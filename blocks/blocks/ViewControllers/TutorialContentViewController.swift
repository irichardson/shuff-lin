//
//  TutorialContentViewController.swift
//  blocks
//
//  Created by Ian Richardson on 8/24/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation

class TutorialContentViewController: UIPageViewController{

    var imageView : UIImageView = UIImageView()
    
    var pageIndex : Int = 0
    var imageName : String = ""
    var viewSize : CGSize = CGSize(width: 280, height: 405)

    override func viewWillLayoutSubviews() {
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image = UIImage(named: self.imageName)
        image = ImageHelper.imageScaledToSize(image!, newSize: viewSize)

        self.imageView = UIImageView(frame: CGRectMake(0, 0, viewSize.width, viewSize.height))
        self.imageView.image = image
        self.view.addSubview(self.imageView)
    }
}