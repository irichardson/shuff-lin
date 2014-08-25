//
//  HomeScene.swift
//  blocks
//
//  Created by Ian Richardson on 7/30/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import SpriteKit
import UIkit
import MessageUI

class HomeScene: SKScene, MFMailComposeViewControllerDelegate {
    
    var gameManager :GameManager = GameManager()
    
    let start :SKButton = SKButton(imageNamed: "play")
    let scores :SKButton = SKButton(imageNamed: "highscore")

    var splashScreen = UIImageView(image: UIImage(contentsOfFile: "splashScreen"))
    
    var settingsOpen = false
    var shareOpen = false
    var mute = false
    
    let settings :SKButton = SKButton(imageNamed: "settings")
    var settingsShelf = SKSpriteNode()
    var sound :SKButton = SKButton()
    var help :SKButton = SKButton(imageNamed: "help")
    var feedback :SKButton = SKButton(imageNamed: "feedback")
    
    let share :SKButton = SKButton(imageNamed: "share")
    var facebook :SKButton = SKButton(imageNamed: "facebook")
    var twitter :SKButton = SKButton(imageNamed: "twitter")
    var shareShelf :SKSpriteNode = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        splashScreen.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
//        self.view.addSubview(splashScreen)
        buildWorld()
    }

    func buildWorld(){
//        self.splashScreen.removeFromSuperview()
        
        self.backgroundColor = UIColor.whiteColor()
        start.setTouchUpInsideTarget(self, action: Selector("startGame"))
        start.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)
        self.addChild(start)
        
        scores.setTouchUpInsideTarget(self, action: Selector("highScores"))
        scores.position = CGPointMake(self.view.bounds.size.width/2, self.start.frame.origin.y-self.start.frame.height/2)
        self.addChild(scores)
        
        var titleLabel = SKSpriteNode(imageNamed: "logo")
        titleLabel.position = CGPointMake(self.view.bounds.size.width/2, self.view.frame.height - titleLabel.frame.height/2)
        self.addChild(titleLabel)
        
        settings.position = CGPoint(x: settings.frame.width/2, y: settings.frame.height/2)
        settings.setTouchUpInsideTarget(self, action: Selector("gameSettings"))

        var prefs = NSUserDefaults.standardUserDefaults()
        let music = prefs.boolForKey("music")
        
        if !music{
            mute = false
            sound = SKButton(imageNamedNormal: "mute", selected: "high_volume")
        }
        else{
            mute = true
            sound = SKButton(imageNamedNormal: "high_volume", selected: "mute")
        }

        sound.position = CGPoint(x: sound.frame.width+sound.frame.width/2 + 10, y: sound.frame.height/2)
        sound.setTouchUpInsideTarget(self, action: Selector("soundOnOff"))
        
        help.position = CGPoint(x: help.frame.width*2+help.frame.width/2 + 20, y: help.frame.width/2)
        help.setTouchUpInsideTarget(self, action: Selector("tutorial"))
        
        feedback.position = CGPoint(x: feedback.frame.width*3+feedback.frame.width/2 + 30, y: feedback.frame.width/2)
        feedback.setTouchUpInsideTarget(self, action: Selector("sendFeedback"))
        
        settingsShelf.addChild(feedback)
        settingsShelf.addChild(sound)
        settingsShelf.addChild(help)
        
        self.addChild(settingsShelf)
        self.addChild(settings)
        
        var close = SKAction.rotateByAngle(-2, duration: 0)
        settingsShelf.runAction(close)
        
        share.position = CGPoint(x:self.view.frame.width - settings.frame.width/2, y: share.frame.height/2)
        share.setTouchUpInsideTarget(self, action: Selector("shareOptions"))
        
        twitter.position = CGPoint(x:-(sound.frame.width+sound.frame.width/2 + 10), y: twitter.frame.height/2)
        twitter.setTouchUpInsideTarget(self, action: Selector("twitterPressed"))
        
        facebook.position = CGPoint(x:-(help.frame.width*2+help.frame.width/2 + 20), y: facebook.frame.width/2)
        facebook.setTouchUpInsideTarget(self, action: Selector("facebookPressed"))
        
        shareShelf.addChild(facebook)
        shareShelf.addChild(twitter)
        shareShelf.position = CGPoint(x:self.view.frame.width, y:0)
        close = SKAction.rotateByAngle(2, duration: 0)
        shareShelf.runAction(close)
        
        self.addChild(shareShelf)
        self.addChild(share)
    }
    
    func soundOnOff(){
        if(mute){
            //stop music player
            mute = false
            sound.normalTexture = SKTexture(imageNamed: "mute")
            AudioManager.sharedInstance.stopAudio()
            
            var prefs = NSUserDefaults.standardUserDefaults()
            prefs.setBool(false, forKey: "music")
            prefs.synchronize()
        }
        else{
            //play music player
            mute = true
            sound.normalTexture = SKTexture(imageNamed: "high_volume")
            AudioManager.sharedInstance.playAudio("EarlyRiser", fileType:"mp3", loop:-1)
            
            var prefs = NSUserDefaults.standardUserDefaults()
            prefs.setBool(true, forKey: "music")
            prefs.synchronize()
        }
    }
    
    func shareOptions(){
        if settingsOpen {
            closeSettings()
        }
    
        if shareOpen {
            closeShare()
        }
        else{
            var close = SKAction.rotateByAngle(-2, duration: 0.5)
            var open = SKAction.rotateByAngle(-2, duration: 0.5)
            share.runAction(close)
            shareShelf.runAction(open)
            shareOpen = true
        }
    }
    
    func sendFeedback(){
        NSNotificationCenter.defaultCenter().postNotificationName("showMailComposer", object: nil)
    }
    
    func tutorial(){
        NSNotificationCenter.defaultCenter().postNotificationName("showTutorial", object: nil)
    }
    
    func twitterPressed(){
        NSNotificationCenter.defaultCenter().postNotificationName("twitter", object: nil)
    }
    
    func facebookPressed(){
        NSNotificationCenter.defaultCenter().postNotificationName("facebook", object: nil)
    }
    
    //These 3 functions can be put into just 1 function
    func startGame(){
        var reveal = SKTransition.crossFadeWithDuration(0.5)
        var scene = GameScene.sceneWithSize(self.view.bounds.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        scene.gameManager = self.gameManager
        self.view.presentScene(scene, transition: reveal)
    }

    func highScores(){
        var reveal = SKTransition.crossFadeWithDuration(0.5)
        var scene = HighScoresScene.sceneWithSize(self.view.bounds.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        scene.gameManager = gameManager
        self.view.presentScene(scene, transition: reveal)
    }

    func gameSettings(){
        if shareOpen {
            closeShare()
        }
    
        if settingsOpen {
            closeSettings()
        }
        else{
            var open = SKAction.rotateByAngle(2, duration: 0.5)
            settings.runAction(open)
            settingsShelf.runAction(open)
            settingsOpen = true
        }
    }
    
    func closeShare(){
        var close = SKAction.rotateByAngle(2, duration: 0.5)
        var open = SKAction.rotateByAngle(2, duration: 0.5)
        share.runAction(open)
        shareShelf.runAction(close)
        shareOpen = false
    }
    
    func closeSettings(){
        var close = SKAction.rotateByAngle(-2, duration: 0.5)
        settings.runAction(close)
        settingsShelf.runAction(close)
        settingsOpen = false
    }
}
