//
//  GameViewController.swift
//  blocks
//
//  Created by Ian Richardson on 6/17/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import UIKit
import SpriteKit
import MessageUI

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
        var sceneData = NSData.dataWithContentsOfFile(path!, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as HomeScene
        archiver.finishDecoding()
        
        return scene
    }
}

class GameViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewWillLayoutSubviews() {
        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendMail", name:"showMailComposer", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendTweet", name:"twitter", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendFacebook", name:"facebook", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "twitterFailed", name:"twitterFailed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "facebookFailed", name:"facebookFailed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTutorial", name:"showTutorial", object: nil)

        if let scene = HomeScene.unarchiveFromFile("HomeScene") as? HomeScene {
            // Configure the view.
            let skView = self.view as SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.size = UIScreen.mainScreen().bounds.size
            skView.presentScene(scene)
        }
    }

    func sendTweet(){
        var alert = UIAlertController(title: "Twitter", message: "Posting your highscore to Twitter", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            postTweet.tweetWithPhoto("twitterIcon", status: "My highest score in Shuff-Lin is - and my longest word is -")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func sendFacebook(){
        var alert = UIAlertController(title: "Facebook", message: "Posting your highscore to Facebook", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            postFacebook.postToFacebookWithImage("Testicles 1 2", appID:"354809358003876", photo:"twitterIcon")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func sendMail(){
        if(MFMailComposeViewController.canSendMail()){
            var myMail = MFMailComposeViewController()
            myMail.mailComposeDelegate = self
        
            // set the subject
            myMail.setSubject("Feedback about Shuff-Lin")

            //To recipients
            var toRecipients = ["metsul.limited@gmail.com"]
            myMail.setToRecipients(toRecipients)

            //Add some text to the message body
            var sentfrom = "Email sent from my Shuff-Lin"
            myMail.setMessageBody(sentfrom, isHTML: true)

            //Display the view controller
            self.presentViewController(myMail, animated: true, completion: nil)
        }
        else{
            var alert = UIAlertController(title: "Alert", message: "Your device cannot send emails", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    func mailComposeController(controller: MFMailComposeViewController!,
        didFinishWithResult result: MFMailComposeResult,
        error: NSError!){

        switch(result.value){
        case MFMailComposeResultSent.value:
            println("Email sent")
        default:
            println("Whoops")
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func twitterFailed(){
        var alert = UIAlertController(title: "Alert", message: "Access to Twitter failed", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func facebookFailed(){
        var alert = UIAlertController(title: "Alert", message: "Access to Facebook failed", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showTutorial(){
        var tutorialController = TutorialViewController()
        tutorialController.modalPresentationStyle = UIModalPresentationStyle.Custom
                
        //Display the view controller
        self.presentViewController(tutorialController, animated: true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
