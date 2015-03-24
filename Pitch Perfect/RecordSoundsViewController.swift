//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aaron Guevara on 3/10/15.
//  Copyright (c) 2015 Quetzal Group LLC. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordMessage: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set value of recording message
        recordMessage.text = "Tap to Record"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
        
        //Set recording in progress message
        recordMessage.text = "Recording in Progress"
        recordButton.enabled=false
        stopButton.hidden=false
        
        //set directory path to store recordings.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //create values for file name to store when recording is done by the user.
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //record voice from user
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //verify that recording has finsihed recording
        if (flag)
        {
            recordedAudio = RecordedAudio(filePathValue: recorder.url, titleValue: recorder.url.lastPathComponent!)
        }
        else
        {
            println("Recording was not successful")
            recordButton.enabled=true
            stopButton.hidden=true
        }
        
        
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //set the recorded audio as tdata for the playsoundsvc
        if (segue.identifier=="stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        //stop recording button has been pressed by user.
        recordMessage.text = "Tap to Record"
        
        //set buttons state
        recordButton.enabled=true
        stopButton.hidden=true
        
        //stop audio recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden=true
        recordButton.enabled=true
    }
    
    
}

