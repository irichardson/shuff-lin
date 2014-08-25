//
//  Score.swift
//  blocks
//
//  Created by Ian Richardson on 8/25/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation

class Score: NSObject, NSCoding{
    
    var score : Int = 0
    var word : String!
    
    override init(){
    }
    
    required init(coder aDecoder: NSCoder) {
        score = Int(aDecoder.decodeIntForKey("score"))
        word = aDecoder.decodeObjectForKey("word") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(score, forKey: "score")
        aCoder.encodeObject(word, forKey: "word")
    }

}