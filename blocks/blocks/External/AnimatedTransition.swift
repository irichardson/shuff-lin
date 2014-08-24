//
//  AnimatedTransition.swift
//  blocks
//
//  Created by Ian Richardson on 8/24/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import UIKit

class AnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning{
    
    var isPresenting: Bool!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return 0.25
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        var inView = transitionContext.containerView()
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        inView.addSubview(toVC.view)
        
        var screenRect = UIScreen.mainScreen().bounds
        toVC.view.frame = CGRectMake(0, screenRect.size.height, fromVC.view.frame.size.width, fromVC.view.frame.size.height)
        UIView.animateWithDuration(0.25, delay: 0.0, options: nil, animations: {
            toVC.view.frame = CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)
        }
        , completion: {(completed: Bool) -> Void in
            transitionContext.completeTransition(completed)
        })
    }

}