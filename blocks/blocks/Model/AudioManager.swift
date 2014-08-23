//
//  AudioManager.swift
//  blocks
//
//  Created by Ian Richardson on 8/22/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager {
    
    var audioPlayer = AVAudioPlayer()

    class var sharedInstance: AudioManager {
        struct Static {
            static var instance: AudioManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = AudioManager()
        }
        return Static.instance!
    }
    
    func playAudio(fileName: String, fileType: String, loop: Int){
        var url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)!)
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        audioPlayer.play()
        audioPlayer.numberOfLoops = loop
    }
    
    func stopAudio(){
        audioPlayer.stop()
    }
}