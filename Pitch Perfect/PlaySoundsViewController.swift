//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aaron Guevara on 3/11/15.
//  Copyright (c) 2015 Quetzal Group LLC. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    var receivedAudio:RecordedAudio!
    var audioEngine : AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This is the code so that the sound in playback is played over the iPhone main speakers
        //By overriding the degault audio out put
        let session = AVAudioSession.sharedInstance()
        var error: NSError?
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
        session.setActive(true, error: &error)
        
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        //Enabling rate modification for palying chipmonk and darth vader sound
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //Calling function to set variable pitch update
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    func playAudioWithVariablePitch(pitch: Float) {
        //Stop playing current sound and start play from the beginning.
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //attached audio node to engine for play
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Update the pitch value for the pitch effect.
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //make the pitch value udpate part of the audioengine object for play
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        //play audio.
        audioPlayerNode.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func playSoundFast(sender: UIButton) {
        //Stop playing current sound and start play from the beginning.
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        playSound(1.5)
    }
    
    
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
        
    }
    
    func playSound(rateSound: Float) {
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rateSound
        audioPlayer.play()
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        //Stop playing current sound and start play from the beginning.
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        playSound(0.5)
    }
}

