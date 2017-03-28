//
//  RecordSoundViewControler.swift
//  PitchPerfect
//
//  Created by Abhishek Prajapati on 3/23/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewControler: UIViewController, AVAudioRecorderDelegate {

    //audio recorder property
    var audioRecorder: AVAudioRecorder!

    
    //UI elements
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //change the app backgroud to white
        self.view.backgroundColor = UIColor.white
        
        
        //set app title
        self.title = "Pitch Perfect";
        //self.navigationItem.title = "pitch perfect" //this also works
        
        //hide the stop button and display text to recording label
        stopRecordingButton.isHidden = true;
        //stopRecordingButton.isEnabled = false;
        recordingLabel.text = "Tap to record!"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/

    //when record button is pressed
    @IBAction func recordAudio(_ sender: Any) {
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
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

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
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording was not successful")
        }
    }
    
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

