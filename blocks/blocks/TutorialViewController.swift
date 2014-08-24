//
//  TutorialViewController.swift
//  blocks
//
//  Created by Ian Richardson on 8/24/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource{

    var close: UIButton = UIButton()
    var pageViewController : UIPageViewController?
    var pageImages : Array<String> = ["a", "b", "c"]
    var currentIndex : Int = 0

    override func viewWillLayoutSubviews() {
        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        close = UIButton.buttonWithType(UIButtonType.System) as UIButton
        close.frame = CGRectMake(self.view.frame.width - 25, 13, 25, 25)
        close.backgroundColor = UIColor.greenColor()
        close.setTitle("X", forState: UIControlState.Normal)
        close.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(close)
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.dataSource = self
        
        let startingViewController: TutorialContentViewController = self.viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.pageViewController!.view.frame = CGRectMake(25, 25, self.view.frame.size.width-50, self.view.frame.size.height-50);
        
        self.pageViewController!.view.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor.clearColor()
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)            
    }
    
    func close(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController!
    {
        var index = (viewController as TutorialContentViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        println("Decreasing Index: \(String(index))")
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController!
    {
        var index = (viewController as TutorialContentViewController).pageIndex

        if index == NSNotFound {
            return nil
        }
        
        index++
        
        println("Increasing Index: \(String(index))")
        
        if (index == self.pageImages.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> TutorialContentViewController?
    {
        if self.pageImages.count == 0 || index >= self.pageImages.count
        {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = TutorialContentViewController()
        pageContentViewController.imageName = self.pageImages[index]
        pageContentViewController.pageIndex = index
        self.currentIndex = index
        pageContentViewController.viewSetup()


        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }

}