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

    let back :SKButton = SKButton(imageNamed: "homeIcon")
    var scores :[Score] = []
    var gameManager = GameManager()

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        buildWorld()
    }

    func buildWorld(){
        self.backgroundColor = UIColor.whiteColor()
        
        var topBar = SKSpriteNode(imageNamed: "highScoreTopBar")
        topBar.position = CGPointMake(self.frame.width/2, self.frame.height-topBar.frame.height/2)
        self.addChild(topBar)
        topBar.zPosition = 10

        var prefs = NSUserDefaults.standardUserDefaults()
        if var data: AnyObject = prefs.objectForKey("highScores") {
            scores = NSKeyedUnarchiver.unarchiveObjectWithData(data as NSData) as [Score]
        }
        
        back.setTouchUpInsideTarget(self, action: Selector("backToMenu"))
        back.size = CGSizeMake(30, 30)
        back.position = CGPointMake(-130, 0)
        topBar.addChild(back)
        
        var yPosition = 490
        
        if(Int(UIScreen.mainScreen().bounds.height) == iPhone4){
            yPosition = 400
        }
        
        for index in 1...10{
            var number = SKSpriteNode(imageNamed: "\(index)")
            number.name = "HighScores"
            number.position = CGPointMake(number.frame.width, CGFloat(yPosition))
            self.addChild(number)
            
            if(scores.count >= index){
                var scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
                scoreLabel.fontSize = 30;
                scoreLabel.fontColor = UIColor.blackColor()
                scoreLabel.position = CGPoint(x:number.frame.width*3, y:CGFloat(yPosition-10));
                scoreLabel.text = "\(scores[index-1].score) - \(scores[index-1].word)"
                scoreLabel.name = "HighScores"
                
                self.addChild(scoreLabel)
            }
            
            yPosition -= 50
        }
                
        if(Int(UIScreen.mainScreen().bounds.height) == iPhone4){
            self.enumerateChildNodesWithName("HighScores") {
                node, stop in
                var up = SKAction.moveToY(node.position.y+100, duration: 2)
                var down = SKAction.moveToY(node.position.y, duration: 2)
                var sequence = SKAction.sequence([up, down])
                node.runAction(SKAction.repeatActionForever(sequence))
            }
        }
    }
    
    func backToMenu(){
        var reveal = SKTransition.crossFadeWithDuration(0.5)
        var scene = HomeScene.sceneWithSize(self.view.bounds.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        scene.gameManager = gameManager
        self.view.presentScene(scene, transition: reveal)
    }

}
