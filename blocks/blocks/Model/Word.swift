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
    
    func getStartingPosition() -> Int{
        if(letters.count>0){
            return startingPoints[letters.count-1]
        }
        return startingPoints[0]
    }
    
    func arrangeLetters(){
        for a: Letter in letters{
            var pos = startingPoints[find(letters, a)!]
            a.moveToPosition(CGFloat(pos))
            a.positionInWord = find(letters, a)!
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
            self.letters.removeAtIndex(find(self.letters, letter)!)
        }
    }
    
    func shuffle(){
        for (var i = 0; i < letters.count; i++) {
            var j = arc4random_uniform(UInt32(letters.count))
            var a = letters[Int(j)]
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
}