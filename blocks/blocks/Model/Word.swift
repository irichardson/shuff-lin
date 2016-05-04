//
//  Word.swift
//  blocks
//
//  Created by Ian Richardson on 6/20/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation
import UIKit

class Word {
    let maxSize = 7
    var letters = [Letter]()
    let startingPoints = [22, 68, 114, 160, 206, 252, 298]
    let generatationPosition = [32, 96, 160, 224, 288]
    
    func getStartingPosition() -> Int{
        if(letters.count>0){
            return startingPoints[letters.count-1]
        }
        return startingPoints[0]
    }
    
    func arrangeLetters(){
        for a: Letter in letters{
            let pos = startingPoints[letters.indexOf(a)!]
            a.moveToPosition(CGFloat(pos))
            a.positionInWord = letters.indexOf(a)!
        }
    }
    
    func bringLetterToFront(letter: Letter){
        letter.removeAllActions()
        letter.xScale = 2.0
        letter.yScale = 2.0
    }
    
    func removeAllLetters(){
        for letter: Letter in letters{
            letter.submitted()
            self.letters.removeAtIndex(self.letters.indexOf(letter)!)
        }
    }
    
    func shuffle(){
        for i in 0 ..< letters.count {
            let j = arc4random_uniform(UInt32(letters.count))
            let a = letters[Int(j)]
            letters[Int(j)] = letters[i]
            letters[i] = a
        }
        arrangeLetters()
    }
    
    func notAWord(){
        for letter: Letter in letters{
            letter.wiggle()
        }
    }
    
    func getWord() -> String{
        var word : String = ""
        for letter:Letter in self.letters{
            word += letter.letterValue
        }
        return word
    }
}