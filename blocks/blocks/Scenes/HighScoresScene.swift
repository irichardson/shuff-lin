//
//  HighScoresScene.swift
//  blocks
//
//  Created by Ian Richardson on 7/30/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import SpriteKit

class HighScoresScene: SKScene {

    let iPhone4 = 480
    let yAnimation = 150

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
        
        var topBar = SKSpriteNode(imageNamed: "highScoreTopBar")
        topBar.position = CGPointMake(self.frame.width/2, self.frame.height-topBar.frame.height/2)
        topBar.zPosition = 10
        
        back = SKButton(imageNamed: "homeIcon")
        back.setTouchUpInsideTarget(self, action: Selector("backToMenu"))
        back.size = CGSizeMake(30, 30)
        back.position = CGPointMake(-130, 0)
        topBar.addChild(back)
        
        self.addChild(topBar)
        
        sceneView = SKView(frame: CGRectMake(0, self.frame.height-topBar.frame.height, self.frame.width, self.frame.height))

        var prefs = NSUserDefaults.standardUserDefaults()
        if var data: AnyObject = prefs.objectForKey("highScores") {
            scores = NSKeyedUnarchiver.unarchiveObjectWithData(data as NSData) as [Score]
        }

        var yPosition = 490
        var imageSize:CGFloat = 45.0
        
        if(Int(UIScreen.mainScreen().bounds.height) == iPhone4){
            yPosition = 400
            imageSize = 35.0
        }
        
        for index in 1...10{
            var number = SKSpriteNode(imageNamed: "\(index)")
            number.name = "HighScores"
            number.size = CGSizeMake(imageSize, imageSize)
            number.position = CGPointMake(number.frame.width, CGFloat(yPosition))
            self.addChild(number)
            
            if(scores.count >= index){
                var scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
                scoreLabel.fontSize = 30;
                scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                scoreLabel.fontColor = UIColor.blackColor()
                scoreLabel.position = CGPoint(x:number.frame.origin.x + number.frame.width + 10, y:CGFloat(yPosition-10));
                scoreLabel.text = "\(scores[index-1].score) - \(scores[index-1].word)"
                scoreLabel.name = "HighScores"
                
                self.addChild(scoreLabel)
            }
            
            yPosition -= Int(imageSize)+5
        }
    }
    
    func backToMenu(){
        var reveal = SKTransition.crossFadeWithDuration(0.5)
        var scene = HomeScene.sceneWithSize(self.view.bounds.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.view.presentScene(scene, transition: reveal)
    }
}
