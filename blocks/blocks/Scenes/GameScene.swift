//
//  GameScene.swift
//  blocks
//
//  Created by Ian Richardson on 6/17/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene{
    
    var startGamePlay :Bool = true
    var gameHasStarted :Bool = false
    var timerRemaining :Bool = false
    var countDown :Bool = true
    
    //Controls the game, add scores, checks words
    var gameManager :GameManager = GameManager()
    
    //Labels for the entire game
    var gameStartsLabel :SKLabelNode = SKLabelNode()
    var countDownLabel :SKLabelNode = SKLabelNode()
    var timeRemainingLabel :SKLabelNode = SKLabelNode()
    var scoreLabel :SKLabelNode = SKLabelNode()
    var loadingLabel :SKLabelNode = SKLabelNode()
    
    //Countdown timer for the game
    var startTime :NSTimeInterval = NSTimeInterval()
    
    //Timer to display how long is left in the game
    var lettersTimer :NSTimer = NSTimer()
    
    //Buttons for the gameplay
    let submit :SKButton = SKButton(imageNamed: "submit")
    let back :SKButton = SKButton(imageNamed: "homeIcon")
    
    //Gameover overlay that displays final score
    var gameOverOverlay = SKSpriteNode(imageNamed: "endGame")
    var overlayScore = SKLabelNode(fontNamed:"Chalkduster")
    var home = SKButton(imageNamed: "home")
    var reset = SKButton(imageNamed: "reset")
    
    //Top and bottom bars for the game
    var topBar = SKSpriteNode(imageNamed: "gameTopBar")
    var shelf = SKSpriteNode(imageNamed: "shelf")
    
    //Node used to track which letter should be removed from the shelf
    var letterBeingSwiped: SKSpriteNode = SKSpriteNode()
    
    //Swipe gesture recognizer
    var swipeRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.gameManager.loadDictionaries()
            dispatch_async(dispatch_get_main_queue(), {
                self.countDownLabels()
            })
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "wordFound", name:"wordFound", object: nil)
        buildWorld()
    }
    
    override func willMoveFromView(view: SKView!) {
        self.view.removeGestureRecognizer(swipeRecognizer)
    }
    
    //Setup scene
    func buildWorld(){
        self.backgroundColor = UIColor.whiteColor()
        
        topBar.position = CGPointMake(self.frame.width/2, self.frame.height-topBar.frame.height/2)
        topBar.zPosition = 10
        self.addChild(topBar)
        
        timeRemainingLabel = SKLabelNode(fontNamed:"Chalkduster")
        timeRemainingLabel.text = "\(gameManager.time)";
        timeRemainingLabel.fontSize = 20;
        timeRemainingLabel.fontColor = UIColor.blackColor()
        timeRemainingLabel.position = CGPoint(x:CGRectGetMaxX(self.frame)-30, y:CGRectGetMaxY(self.frame)-40)
        timeRemainingLabel.zPosition = 11
        self.addChild(timeRemainingLabel)
        
        back.setTouchUpInsideTarget(self, action: Selector("backToMenu"))
        back.size = CGSizeMake(30, 30)
        back.position = CGPoint(x:0, y:0)
        back.zPosition = 11
        topBar.addChild(back)
        
        submit.setTouchUpInsideTarget(self, action: Selector("submitWord"))
        submit.size = CGSizeMake(self.frame.width, shelf.frame.height)
        submit.position = CGPointMake(self.frame.width/2, submit.frame.height/2)
        submit.zPosition = 4
        self.addChild(submit)
        
        shelf.position = CGPointMake(self.frame.width/2, submit.frame.height+shelf.frame.height/2)
        shelf.zPosition = 2
        self.addChild(shelf)
        
        scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
        scoreLabel.text = "\(gameManager.score)"
        scoreLabel.fontSize = 20;
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.position = CGPoint(x:70, y:CGRectGetMaxY(self.frame)-40)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        scoreLabel.zPosition = 11
        self.addChild(scoreLabel)
        
        loadingLabel = SKLabelNode(fontNamed:"Chalkduster")
        loadingLabel.fontSize = 60;
        loadingLabel.fontColor = UIColor.blackColor()
        loadingLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        loadingLabel.text = "Loading..."
        self.addChild(loadingLabel)
    }
    
    
    //Add countdown labels
    func countDownLabels(){
        loadingLabel.removeFromParent()
    
        gameStartsLabel = SKLabelNode(fontNamed:"Chalkduster")
        gameStartsLabel.text = "Game Starts in...";
        gameStartsLabel.fontSize = 20;
        gameStartsLabel.fontColor = UIColor.blackColor()
        gameStartsLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+CGRectGetMidY(self.frame)/2);
        
        countDownLabel = SKLabelNode(fontNamed:"Chalkduster")
        countDownLabel.fontSize = 60;
        countDownLabel.fontColor = UIColor.blackColor()
        countDownLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(countDownLabel)
        self.addChild(gameStartsLabel)
    }
    
    //This function is called automatically and is used to change the time on the countdown timer
    override func update(currentTime: NSTimeInterval) {
        if !gameHasStarted{
            startTimer(currentTime)
        }
        else if timerRemaining{
            countDownTimer(currentTime)
        }
    }
    
    
    //Display the time on the countdown timer
    func countDownTimer(currentTime: NSTimeInterval){
        //reset counter if starting
        if (countDown){
            startTime = currentTime
            countDown = false
        }
        var gameCountDown = gameManager.time - Int(currentTime - startTime)
        if(gameCountDown>(-1)){  //if counting down to 0 show counter
            timeRemainingLabel.text = "\(gameCountDown)"
        }
        else {
            gameOver()
        }
    }
    
    func startTimer(currentTime: NSTimeInterval){
        //reset counter if starting
        if (startGamePlay){
            startTime = currentTime
            startGamePlay = false
        }
        var countDownInt = 4 - Int(currentTime - startTime)
        if(countDownInt>0){  //if counting down to 0 show counter
            countDownLabel.text = "\(countDownInt)"
        }
        else { //if not show message, dismiss, whatever you need to do.
            countDownLabel.text = "GO!"
            gameHasStarted = true
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("removeLabel"), userInfo: nil, repeats: false)
        }
    }
    
    //Used to remove all letters after the game and display the overlay for the score
    func gameOver(){
        self.enumerateChildNodesWithName("Letter") {
            node, stop in
            node.removeFromParent()
        }
        
        timerRemaining = false
        lettersTimer.invalidate()
        
        gameOverOverlay.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        gameOverOverlay.zPosition = 5
        self.addChild(gameOverOverlay)
        
        reset.setTouchUpInsideTarget(self, action: Selector("gameReset"))
        reset.position = CGPointMake(0, -100)
        gameOverOverlay.addChild(reset)
                
        home.setTouchUpInsideTarget(self, action: Selector("goHome"))
        home.position = CGPointMake(0, -50)
        gameOverOverlay.addChild(home)
        
        overlayScore.text = "\(gameManager.score)"
        overlayScore.fontSize = 20;
        overlayScore.fontColor = UIColor.blackColor()
        overlayScore.position = CGPoint(x:0, y:0);
        gameOverOverlay.addChild(overlayScore)
        
        timeRemainingLabel.text = "60"
        if gameManager.newHighScore(){
            var star = SKSpriteNode(imageNamed: "star")
            star.position = CGPointMake(-85, 85)
            star.zPosition = 3
            gameOverOverlay.addChild(star)
            
            var newHighScoreLabel = SKSpriteNode(imageNamed: "newHighscore")
            newHighScoreLabel.position = CGPointMake(20, 85)
            newHighScoreLabel.zPosition = 3
            gameOverOverlay.addChild(newHighScoreLabel)
        }
        gameManager.saveScore()
    }
    
    //Reset the game manager and remove the overlay
    func gameReset(){
        overlayScore.removeFromParent()
        home.removeFromParent()
        reset.removeFromParent()
        gameOverOverlay.removeFromParent()
        gameManager.reset()
        startGamePlay = true
        gameHasStarted = false
        timerRemaining = false
        countDown = true
        scoreLabel.text = "0"
        countDownLabels()
    }
    
    //Home page
    func goHome(){
        self.removeAllChildren()
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"wordFound", object: nil)
        var reveal = SKTransition.crossFadeWithDuration(0.5)
        var scene = HomeScene.sceneWithSize(self.view.bounds.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        gameManager.reset()
        self.view.presentScene(scene, transition: reveal)
    }
    
    //Remove starting labels and start adding letters
    func removeLabel(){
        gameStartsLabel.removeFromParent()
        countDownLabel.removeFromParent()
        timerRemaining = true
        lettersTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("addLetters"), userInfo: nil, repeats: true)
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("move:"))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    //If a letter is flicked while on the shelf it is removed
    func move(swipe:UILongPressGestureRecognizer){
        if let letter = letterBeingSwiped as? Letter{
            gameManager.letterFlicked(letter)
            
            //Add particle sparks when XCode is NOT SHIT ANYMORE!!!!!
            letter.runAction(SKAction.scaleTo(0.0, duration: 0.5), completion:{letter.removeFromParent()})
            letterBeingSwiped = SKSpriteNode()
            
            //Add particle sparks when XCode is NOT SHIT ANYMORE!!!!!
            scoreLabel.text = "\(gameManager.score)"
        }
    }
    
    //If the word is legit, animate the latters away
    func wordFound(){
        //Particle sparks are broken!!!!! XCode blows!!!!
        scoreLabel.text = "\(gameManager.score)"
    }
    
    //Submit word button pressed
    func submitWord(){
        gameManager.submitWord()
    }
    
    //Shuffle word button pressed
    func shuffleWord(){
        gameManager.word.shuffle()
    }
    
    //Add a letter to move up the screen
    func addLetters(){
        var letter = gameManager.addLetters()        
        self.addChild(letter)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            selectNodeForTouch(location)
        }
    }
 
    func selectNodeForTouch(point: CGPoint){
        var node = self.nodeAtPoint(point)
        if node is Letter{
            let letter = node as Letter
            if !gameManager.letterOnWordShelf(letter){
                gameManager.word.bringLetterToFront(letter)
            }
            else{
                self.letterBeingSwiped = letter
                letter.zPosition = 4
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            var node = self.nodeAtPoint(location)
            if node is Letter{
                let letter = node as Letter
                letter.position = CGPointMake(location.x, location.y)
                letter.zPosition = 4
            }
        }
    }
 
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            var node = self.nodeAtPoint(location)
            if node is Letter{
                let letter = node as Letter                
                gameManager.addLetterToWord(letter)
                letterBeingSwiped = SKSpriteNode()
            }
        }
    }
    
    func backToMenu(){
        var reveal = SKTransition.crossFadeWithDuration(0.5)
        var scene = HomeScene.sceneWithSize(self.view.bounds.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.view.presentScene(scene, transition: reveal)
    }
}