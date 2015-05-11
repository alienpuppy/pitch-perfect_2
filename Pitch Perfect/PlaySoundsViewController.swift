//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mary Elizabeth McManamon on 4/26/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
/** 
    Manages playback of recorded sounds in our app
    - audioPlayer: plays back slow and fast versions of the recorded sounds
    - audioEngine: plays back different pitched versions of the recorded sounds
    - receivedAudio: contains recorded audio file
    - audioFile: extracted recorded audio file
*/
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
/**
    Initializes audioPlayer (rate) and audioEngine (pitch) for playback
*/
        
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL:receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true

    }
    
/** wrapper routines to play 
    - deep pitched audio file (Darth Vader)
    - high pitched audio file (Chipmuck)
    - fast paced audio file (speedMeUp)
    - slow paced audio file (slowMeDown)
*/
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
        
    }
    
    @IBAction func playChipmuckAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        
    }
    @IBAction func speedMeUp(sender: UIButton) {
        
        playAllAudio(1.5)
    }
    
    @IBAction func slowMeDown(sender: UIButton) {
        
        playAllAudio(0.5)
    }
    
    @IBAction func stopMeCold(sender: UIButton) {
/**
    stops all playback
*/
        
        audioEngine.stop()
        audioPlayer.stop()
    }
    
    func playAllAudio (myRate: Float) {
/** 
    main routine to play paced audio file
    - stop all in progress playback
    - set playback rate and play file
*/
        if (audioEngine.running) {
            audioEngine.stop()
            audioEngine.reset()
        }
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = myRate
        audioPlayer.play()
        
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
/**
    main routine to play pitched audio file
    - stop all in progress playback
    - define pitch and initiate playback
*/
        if (audioPlayer.playing) {
            audioPlayer.stop()
        }
        
        audioEngine.stop()
        audioEngine.reset()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
   
}
