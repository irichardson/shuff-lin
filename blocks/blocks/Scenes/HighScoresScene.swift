//
//  HighScoresScene.swift
//  blocks
//
//  Created by Ian Richardson on 7/30/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import SpriteKit
import UIKit

class HighScoresScene: SKScene {

    let iPhone4 = 480
    let yAnimation = 150
    var yPositionNumber = 490

    var back :SKButton = SKButton()
    var scores :[Score] = []
    var previousLocation = CGPoint()
    
    //ScrollView
    var scrollView :UIScrollView = UIScrollView()
    var sceneView :SKView = SKView()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        buildWorld()
    }

    func buildWorld(){
        self.backgroundColor = UIColor.whiteColor()
        
        let topBar = SKSpriteNode(imageNamed: "highScoreTopBar")
        topBar.position = CGPointMake(self.frame.width/2, self.frame.height-topBar.frame.height/2)
        topBar.zPosition = 10
        
        back = SKButton(imageNamed: "homeIcon")
        back.setTouchUpInsideTarget(self, action:#selector(HighScoresScene.backToMenu))
        back.size = CGSizeMake(30, 30)
        back.position = CGPointMake(-130, 0)
        topBar.addChild(back)
        
        self.addChild(topBar)
        
        sceneView = SKView(frame: CGRectMake(0, self.frame.height-topBar.frame.height, self.frame.width, self.frame.height))

        let prefs = NSUserDefaults.standardUserDefaults()
        if let data: AnyObject = prefs.objectForKey("highScores") {
            scores = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as! [Score]
        }

        var imageSize:CGFloat = 45.0
        
        //Reduce the highscore list to fit on iPhone 4s
        if(Int(UIScreen.mainScreen().bounds.height) == iPhone4){
            yPositionNumber = 400
            imageSize = 35.0
        }
        
        for index in 1...10{
            let number = SKSpriteNode(imageNamed: "\(index)")
            number.name = "HighScores"
            number.size = CGSizeMake(imageSize, imageSize)
            number.position = CGPointMake(number.frame.width, CGFloat(yPositionNumber))
            self.addChild(number)
            
            if(scores.count >= index){
                let scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
                scoreLabel.fontSize = 30;
                scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                scoreLabel.fontColor = UIColor.blackColor()
                scoreLabel.position = CGPoint(x:number.frame.origin.x + number.frame.width + 10, y:CGFloat(yPositionNumber-10));
                scoreLabel.text = "\(scores[index-1].score) - \(scores[index-1].word)"
                scoreLabel.name = "HighScores"
                
                self.addChild(scoreLabel)
            }
            
            yPositionNumber -= Int(imageSize)+5
        }
    }
    
    func backToMenu(){
        let reveal = SKTransition.crossFadeWithDuration(0.5)
        let scene = HomeScene(size:self.view!.bounds.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.view!.presentScene(scene, transition: reveal)
    }
}
