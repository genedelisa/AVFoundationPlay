//
//  Sound.swift
//  AVFoundationPlay
//
//  Created by Gene De Lisa on 1/8/16.
//  Copyright © 2016 Gene De Lisa. All rights reserved.
//

import Foundation
import AVFoundation

// AVAudioPlayerDelegate requires NSObjectProtocol
class Sound : NSObject {
    
    var avPlayer:AVAudioPlayer!
    
    override init() {
        super.init()
        readFileIntoAVPlayer()
    }
    
    func setSessionPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.MixWithOthers)
            try audioSession.setActive(true)
        } catch {
            print("couldn't set category \(error)")
        }
    }
    
    func stopAVPLayer() {
        if avPlayer.playing {
            avPlayer.stop()
        }
    }
    
    func toggleAVPlayer() {
        print("is playing \(avPlayer.playing)")
        if avPlayer.playing {
            avPlayer.pause()
        } else {
            setSessionPlayback()
            avPlayer.play()
        }
    }
    
    /**
     Uses AvAudioPlayer to play a sound file.
     The player instance needs to be an instance variable. Otherwise it will disappear before playing.
     */
    func readFileIntoAVPlayer() {
        
        guard let fileURL = NSBundle.mainBundle().URLForResource("modem-dialing-02", withExtension: "mp3") else {
            print("could not read sound file")
            return
        }
        
        do {
            try self.avPlayer = AVAudioPlayer(contentsOfURL: fileURL)
        } catch {
            print("could not create AVAudioPlayer \(error)")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"sessionInterrupted:",
            name:AVAudioSessionInterruptionNotification,
            object:avPlayer)
        
        print("playing \(fileURL)")
        avPlayer.delegate = self
        avPlayer.prepareToPlay()
        avPlayer.volume = 1.0
    }
    
    
    // MARK: notification callbacks
    func sessionInterrupted(notification:NSNotification) {
        print("audio session interrupted")
        guard let p = notification.object as? AVAudioPlayer else {
            print("weirdness. notification object was not AVAudioPlayer")
            return
        }
        p.stop()
    }
    
}


// MARK: AVAudioPlayerDelegate
extension Sound : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
    }
    
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
}
