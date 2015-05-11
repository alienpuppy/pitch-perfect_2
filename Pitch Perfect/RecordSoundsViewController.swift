//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mary Elizabeth McManamon on 4/26/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
/**
    Manages recording of our audio file within the app  
    
    Class variables
    - recordButton: control that initiates recording within the app
    - recordingText: control that displays status of recording
    - stopButton: control that stops recording within the app
    - audioRecorder: represents the recording mechanism
    - recordedAudio: represents the recorded audio file on the phone
*/
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingText: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
/**
    Defines app's first screen
    - recordingButton is visible and enabled
    - recordingText instucts user how to record
    - stopButton is hidden
*/
        super.viewWillAppear(animated)
        recordButton.enabled = true
        recordingText.hidden = false
        recordingText.text = "Tap To Record"
        stopButton.hidden = true
        
    }
    
    @IBAction func recordAudio(sender: UIButton) {
/**
    Defines app's screen when recording is ongoing
    - greys recordingButton so it can not be used.
    - displays in progress message in recordingText
    - enables stopButton so the recording can be stopped
*/
        
        recordButton.enabled = false
        recordingText.text = "Recording In Progess"
        recordingText.hidden = false
        stopButton.hidden = false
        
/** 
    Builds up unique pathname for the recorded audio file within thephone'sdocument directory

*/
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [docsDir, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
/**
    Initates recording
*/
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
/**
    Checks status of finished recording
    - success: pass recorded audio to seque to next screen of the app
    - failure: display text to user and enable recordingButton so user can try again
*/
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            recordingText.text = "Recording Unsucessful"
            recordButton.enabled = true
            stopButton.hidden = true
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
/** 
    Intialize the seque with recorded file
*/
            
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }

    }

    @IBAction func stopRecording(sender: UIButton) {
/**
  Stop the recording and change the disply to indicate recording has stopped
*/
        recordingText.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
}

