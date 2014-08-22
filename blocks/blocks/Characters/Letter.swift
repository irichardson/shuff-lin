//
//  Letter.swift
//  blocks
//
//  Created by Ian Richardson on 6/20/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import SpriteKit
import UIKit

enum MoveDirection {
    case Forward, Left, Right, Back
}

enum ColliderType: UInt32 {
    case Letter = 1
}

class Letter : SKSpriteNode {
    
    //Constants
    let speedForShelf: Double = 0.002
    let movementSpeed: CGFloat = 200.0
    let finishingLocation: CGFloat = -30
    let topOffset: CGFloat = 100
    let bottomOffset: CGFloat = 125
    
    var positionInWord: Int = 0
    var inTransit: Bool = false
    var letterValue: String
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
}
    
    init(letter: String, atPosition position: CGPoint) {
        let texture = SKTexture(imageNamed: letter)
        let size = CGSizeMake(45, 45)
        letterValue = letter
        super.init(texture: texture, color: SKColor.whiteColor(), size: size)
        self.position = position
        self.name = "Letter"
    }
    
    //Move animation is handled here
    func moveToPosition(xPosition: CGFloat){
        var xAxis: CGFloat = 0
        var yAxis: CGFloat = 0
        if(xPosition > self.position.x){
            xAxis = xPosition - self.position.x
        }
        else if(xPosition < self.position.x){
            xAxis = self.position.x - xPosition
        }
        yAxis = self.position.y - topOffset
        
        var hypothenus = sqrt((xAxis * xAxis) + (yAxis * yAxis))
        var time = Double(hypothenus)*speedForShelf
        
        let action = SKAction.moveTo(CGPointMake(xPosition, bottomOffset), duration: NSTimeInterval(time))
        self.runAction(action)
    }
    
    func setupPhysics(){
        self.physicsBody = SKPhysicsBody(rectangleOfSize:self.frame.size)
        self.physicsBody.dynamic = true
        self.physicsBody.categoryBitMask = ColliderType.Letter.toRaw()
        self.physicsBody.contactTestBitMask = ColliderType.Letter.toRaw()
        self.physicsBody.collisionBitMask = 0;
    }
    
    func moveUp(distance: Double, speedForScene: Double){
        var time = distance * speedForScene
        let action = SKAction.moveTo(CGPointMake(self.position.x, UIScreen.mainScreen().bounds.height+self.frame.size.height), duration: time)
        self.runAction(SKAction.repeatActionForever(action))
    }
    
    func submitted(){
        self.removeAllActions()
        let down = SKAction.moveTo(CGPointMake(self.position.x, finishingLocation), duration: 0.3)
        self.runAction(down)
    }
    
    func wiggle(){
        self.zPosition = 6
        //spin around
        self.runAction(SKAction.rotateByAngle(0.5, duration: 0.05), completion: {
            self.runAction(SKAction.rotateByAngle(-0.5, duration: 0.05), completion: {
                self.runAction(SKAction.rotateByAngle(-0.5, duration: 0.05), completion: {
                    self.runAction(SKAction.rotateByAngle(0.5, duration: 0.05), completion: {
                        self.zPosition = 3
                    })
                })
            })
        })
    }

}
