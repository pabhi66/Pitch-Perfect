//
//  RecordSoundViewControler.swift
//  PitchPerfect
//
//  Created by Abhishek Prajapati on 3/23/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import AVFoundation
private var display: CADisplayLink?

class RecordSoundViewControler: UIViewController, AVAudioRecorderDelegate {

    //audio recorder property
    var audioRecorder: AVAudioRecorder!

    
    //UI elements and buttons
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var audioVisualizer: SoundWaveVisualizer!
    @IBOutlet weak var audioVisualizer2: SoundWaveVisualizer!
    @IBOutlet weak var audioVisualizer3: SoundWaveVisualizer!
    @IBOutlet weak var audioVisualizer4: SoundWaveVisualizer!
    @IBOutlet weak var horizontal: UIView!
    @IBOutlet weak var verticleView: UIView!
    
    //view will load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.]
        
        //set app title
        self.title = "Pitch Perfect";
        //self.navigationItem.title = "pitch perfect" //this also works
        
        //hide the stop button and display text to recording label
        stopRecordingButton.isHidden = true;
        //stopRecordingButton.isEnabled = false;
        recordingLabel.text = "Tap to record!"

    }
    
    //view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get device orientation
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        audioVisualizer.backgroundColor = UIColor.clear
        audioVisualizer4.backgroundColor = UIColor.clear
        audioVisualizer2.backgroundColor = UIColor.clear
        audioVisualizer3.backgroundColor = UIColor.clear
        
        // change Layout screen
        if orientation.isPortrait {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.verticleView.isHidden = false
                self.horizontal.isHidden = true
            }
        } else if orientation.isLandscape {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.verticleView.isHidden = true
                self.horizontal.isHidden = false
            }
        }
    }
    
    //when user rotates screen
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Get device orientation
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        //change Layout screen
        if orientation.isPortrait {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.verticleView.isHidden = false
                self.horizontal.isHidden = true
            }
        } else if orientation.isLandscape {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.verticleView.isHidden = true
                self.horizontal.isHidden = false
            }
        }
    }


    //when record button is pressed
    @IBAction func recordAudio(_ sender: Any) {
        //change text and show stop button
        recordingLabel.text = "Tap to stop recording"
        stopRecordingButton.isHidden = false;
        recordButton.isHidden = true;
        
        //record the audio and store it
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        display = CADisplayLink(target: self, selector: #selector(update))
        display?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //update the wave frequency
    @objc func update(){
        var normalizedValue: Float = 0.0
        var time = 0.0
        
        audioRecorder.updateMeters()
        let decibels = audioRecorder.averagePower(forChannel: 0)
        normalizedValue = getPower(decibels)
        time = audioRecorder.currentTime
        
        audioVisualizer.updateWithPowerLevel(normalizedValue)
        audioVisualizer2.updateWithPowerLevel(normalizedValue)
        audioVisualizer3.updateWithPowerLevel(normalizedValue)
        audioVisualizer4.updateWithPowerLevel(normalizedValue)
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        self.time.text = String(format: "%02d:%02d", minutes, seconds)
        
    }
    
    //get wave power
    func getPower(_ decibels: Float) -> Float {
        if (decibels == 0.0 || decibels < -60.0) {
            return 0.0
        }
        
        return powf((pow(10.0, 0.05 * decibels) - pow(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - pow(10.0, 0.05 * -60.0))), 1.0 / 2.0)
    }

    //when stop button is pressed
    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text = "Tap to record!"
        stopRecordingButton.isHidden = true;
        recordButton.isHidden = false;
        
        //stop recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //after stop recording navigate to play screen
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording was not successful")
        }
    }
    
    //prepare to navigate to different view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            //change back button title
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

