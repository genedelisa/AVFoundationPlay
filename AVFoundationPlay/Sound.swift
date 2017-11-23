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
class Sound: NSObject {
    
    var avPlayer: AVAudioPlayer!
    
    override init() {
        super.init()
        readFileIntoAVPlayer()
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    func setSessionPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .mixWithOthers)
            try audioSession.setActive(true)
        } catch {
            print("couldn't set category \(error)")
        }
    }
    
    func stopAVPLayer() {
        if avPlayer.isPlaying {
            avPlayer.stop()
        }
    }
    
    func toggleAVPlayer() {
        print("is playing \(avPlayer.isPlaying)")
        if avPlayer.isPlaying {
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
        
        guard let fileURL = Bundle.main.url(forResource: "modem-dialing-02", withExtension: "mp3") else {
            print("could not read sound file")
            return
        }
        
        do {
            try self.avPlayer = AVAudioPlayer(contentsOf: fileURL)
            //try self.avPlayer = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: AVFileTypeMPEGLayer3)

        } catch {
            print("could not create AVAudioPlayer \(error)")
            return
        }
        
        print("playing \(fileURL)")
        avPlayer.delegate = self
        avPlayer.prepareToPlay()
        avPlayer.volume = 1.0
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionRouteChange(_:)),
                                               name: NSNotification.Name.AVAudioEngineConfigurationChange,
                                               object: self.avPlayer)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionRouteChange(_:)),
                                               name: NSNotification.Name.AVAudioSessionInterruption,
                                               object: self.avPlayer)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionRouteChange(_:)),
                                               name: NSNotification.Name.AVAudioSessionRouteChange,
                                               object: self.avPlayer)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.AVAudioEngineConfigurationChange,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.AVAudioSessionInterruption,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.AVAudioSessionRouteChange,
                                                  object: nil)
    }
    
    @objc
    func sessionRouteChange(_ notification: Notification) {
        print("sessionRouteChange")
        if let player = notification.object as? AVAudioPlayer {
            player.stop()
        }
        
        if let userInfo = notification.userInfo as? [String: Any?] {
            
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? AVAudioSessionRouteChangeReason {
                
                print("audio session route change reason \(reason)")
                
                switch reason {
                case .categoryChange: print("CategoryChange")
                case .newDeviceAvailable:print("NewDeviceAvailable")
                case .noSuitableRouteForCategory:print("NoSuitableRouteForCategory")
                case .oldDeviceUnavailable:print("OldDeviceUnavailable")
                case .override: print("Override")
                case .wakeFromSleep:print("WakeFromSleep")
                case .unknown:print("Unknown")
                case .routeConfigurationChange:print("RouteConfigurationChange")
                }
            }
            
            if let previous = userInfo[AVAudioSessionRouteChangePreviousRouteKey] {
                print("audio session route change previous \(String(describing: previous))")
            }
        }
    }
    
    
}


// MARK: AVAudioPlayerDelegate
extension Sound: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
    }
    
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
}
