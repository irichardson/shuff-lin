//
//  GameManager.swift
//  blocks
//
//  Created by Ian Richardson on 6/23/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation

class GameManager{

    //Constants
    var min : Int = 0
    var max : Int = 0
    let startingY : CGFloat = 50
    //Constants
    
    var score = 0
    var word = Word()
    var alphabet = [String]()
    var dictionary = [String]()
    var scoringDictionary = [String:Int]()
    
    var speedOfLetters : Float = 0.005
    var time : Int = 60
    
    var startTime :NSTimeInterval = NSTimeInterval()
    var timer = NSTimer()
    
    var mostComplexWord : String = ""
    var biggestScore: Int = 0

    func loadDictionaries(){
        loadAlphabet()
        loadScoreDictionary()
        loadWordDictionary()        
    }

    func loadAlphabet(){
        let path = NSBundle.mainBundle().pathForResource("AlphabetFrequency", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        for (letter : AnyObject, number : AnyObject) in dict {
            for var index=0; index < Int(number as NSNumber); index++ {
                alphabet.append(letter as NSString)
            }
        }
    }
    
    func loadScoreDictionary(){
        let path = NSBundle.mainBundle().pathForResource("scoring", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        for (letter : AnyObject, number : AnyObject) in dict {
            var score = Int(number as NSNumber)
            scoringDictionary[letter as String] = score
        }
    }
    
    func loadWordDictionary(){
        let path = NSBundle.mainBundle().pathForResource("dictionary", ofType: "txt")
        var possibleContent = String.stringWithContentsOfFile(path!, encoding: NSUTF8StringEncoding, error: nil)
        if let content = possibleContent {
            dictionary = content.componentsSeparatedByString("\n")
            self.max = dictionary.count-1
        }
    }
    
    init(){        
    }
    
    func submitWord(){
        var word = self.word.getWord()
        word += "\r"
        binarySearch(word, imin: min, imax: max)
    }
    
    func binarySearch(key: String, imin: Int, imax: Int) {
        //find the value at the middle index
        var midIndex : Double = round(Double((imin + imax) / 2))
        var midNumber = dictionary[Int(midIndex)]

        //use recursion to reduce the possible search range
        if(imax < imin){
            word.notAWord()
        }
        else if (midNumber > key ) {
            binarySearch(key, imin: imin, imax: Int(midIndex) - 1)
        }
        else if (midNumber < key ) {
            binarySearch(key, imin: Int(midIndex) + 1, imax: imax)
        }
        else if (midNumber == key ){
            addScore()
            NSNotificationCenter.defaultCenter().postNotificationName("wordFound", object: nil)
        }
    }    

    func addLetters() -> Letter{
        let randomNumber = arc4random_uniform(1000)
        let letterPosition = arc4random_uniform(5)
        var xPosition:Int = word.generatationPosition[letterPosition.hashValue]
        
        let letter = Letter(letter: alphabet[Int(randomNumber)], atPosition: CGPointMake(CGFloat(xPosition), startingY))
        var distance = UIScreen.mainScreen().bounds.height-letter.position.y
        letter.moveUp(Double(distance), speedForScene:Double(speedOfLetters))
        letter.zPosition = 1
        return letter
    }
    
    func letterFlicked(letter: Letter){
        self.word.letters.removeAtIndex(find(self.word.letters, letter)!)
        word.arrangeLetters()
        if(score >= 3){
            score -= 3
        }
    }
    
    func newHighScore() -> Bool{
        var prefs = NSUserDefaults.standardUserDefaults()
        var scores : [Score] = []
        if var data: AnyObject = prefs.objectForKey("highScores") {
            scores = NSKeyedUnarchiver.unarchiveObjectWithData(data as NSData) as [Score]
            if isScoreBiggerThanCurrentScores(scores){
                return true
            }
        }
        return false
    }
    
    func isScoreBiggerThanCurrentScores(scores : [Score]) -> Bool{
        var tempScore :Int = 0
        for score: Score in scores {
            if tempScore < score.score  {
                tempScore = score.score
            }
        }
        if tempScore < self.score {
            return true
        }
        else{
            return false
        }
    }
    
    func saveScore(){
        if(score>0){
            var newScore = Score()
            newScore.word = mostComplexWord
            newScore.score = score
        
            var scores :[Score] = []
            var prefs = NSUserDefaults.standardUserDefaults()
            if var data: AnyObject = prefs.objectForKey("highScores") {
                scores = NSKeyedUnarchiver.unarchiveObjectWithData(data as NSData) as [Score]
                if(scores.count == 10){
                    scores.removeLast()
                }
                scores.append(newScore)
            }
            else{
                scores = [newScore]
            }
            
            if scores.count > 1 {
                scores = sorted(scores) {$0.score > $1.score}
            }
            
            var dataArray = NSKeyedArchiver.archivedDataWithRootObject(scores)
            prefs.setObject(dataArray, forKey: "highScores")
            prefs.synchronize()
        }
    }
    
    func nodeOnWordShelf(letter: Letter) -> Bool{
        if find(word.letters, letter) != nil{
            return true
        }
        return false
    }
    
    func reset(){
        self.score = 0
        self.time = 60
        self.word.letters.removeAll(keepCapacity: true)
        self.mostComplexWord = ""
        self.biggestScore = 0
    }
    
    func addScore(){
        var newScore = 0
        for letter:Letter in word.letters{
            newScore += scoringDictionary[letter.letterValue]!
        }

        if(newScore>biggestScore){
            biggestScore = newScore
            mostComplexWord = self.word.getWord()
        }        
        self.word.removeAllLetters()
        score += newScore
        time += newScore
    }
    
    func addLetterToWord(letter: Letter){
        letter.removeAllActions()
        letter.xScale = 1.0
        letter.yScale = 1.0
        letter.zPosition = 3
        if !nodeOnWordShelf(letter){
            if(canAddLetter()){
                if !letter.inTransit{
                    //We can use this for sparks or collisions later
                    word.letters.append(letter)
                    letter.positionInWord = find(word.letters, letter)!
                    letter.inTransit = true
                    letter.moveToPosition(CGFloat(word.getStartingPosition()))
                }
            }
            else{
                var distance = UIScreen.mainScreen().bounds.height - letter.position.y
                letter.moveUp(Double(distance), speedForScene:Double(speedOfLetters))
            }
        }
        else{
            rearrangeLetters(letter)
        }
    }

    func canAddLetter() -> Bool{
        return word.letters.count < word.maxSize
    }

    func rearrangeLetters(letter: Letter){
        var touchingLetters = [Letter]()
        
        for letterSprite: Letter in word.letters {
            if(letterSprite != letter){
                if(CGRectIntersectsRect(letter.frame, letterSprite.frame)){
                    touchingLetters.append(letterSprite)
                }
            }
        }
        
        if(touchingLetters.count>0 ){
            if touchingLetters.count<2 {
                self.moveLetterToPosition(letter.positionInWord, newPosition: touchingLetters[0].positionInWord, letter: letter)
            }
            else{
                if letter.positionInWord < touchingLetters[0].positionInWord {
                    self.moveLetterToPosition(letter.positionInWord, newPosition: touchingLetters[0].positionInWord, letter: letter)
                }
                else{
                    self.moveLetterToPosition(letter.positionInWord, newPosition: touchingLetters[1].positionInWord, letter: letter)
                }                
            }
        }
        
        word.arrangeLetters()
    }
    
    func moveLetterToPosition(letterPosition: Int, newPosition: Int, letter: Letter){
        word.letters.removeAtIndex(letterPosition)
        word.letters.insert(letter, atIndex: newPosition)
    }
    
}
