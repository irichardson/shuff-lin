//
//  GameManager.swift
//  blocks
//
//  Created by Ian Richardson on 6/23/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation
import UIKit
import XCPlayground
import QuartzCore

//var test = GameManager()
//test.binarySearch("word/r", imin: 0, imax: 78691)

let path = NSBundle.mainBundle().pathForResource("dictionary", ofType: "txt")
var dictionary = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)?.componentsSeparatedByString("\n")

func binarySearch(key: String, imin: Int, imax: Int, dictionary: [String]){
    //find the value at the middle index
    var midIndex : Double = round(Double((imin + imax) / 2))
    
    var midNumber = dictionary[Int(midIndex)]
    println("\(midIndex)")
    //use recursion to reduce the possible search range
    if (midNumber > key ) {
        binarySearch(key, imin, Int(midIndex) - 1, dictionary)
    }
    else if (midNumber < key ) {
        binarySearch(key, Int(midIndex) + 1, imax, dictionary)
    }
    else {
        println("value \(key) found..")
    }
}

binarySearch("word", 0, 7800, dictionary!)
