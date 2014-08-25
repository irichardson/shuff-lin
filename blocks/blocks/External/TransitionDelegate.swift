//
//  TransitionDelegate.swift
//  blocks
//
//  Created by Ian Richardson on 8/24/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate{

    func presentationControllerForPresentedViewController(presented: UIViewController!, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController!) -> UIPresentationController! {
        if presented == self {
            return TutorialPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        return nil
    }

    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        if presented == self {
            return AnimatedTransition(isPresenting: true)
        }
        else {
            return nil
        }
    }

    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        if dismissed == self {
            return AnimatedTransition(isPresenting: false)
        }
        else {
            return nil
        }
    }
    
}