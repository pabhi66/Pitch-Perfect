//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Abhishek Prajapati on 3/23/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
 

    var recordedAudioURL: URL! //location to recorded url
    var audioFile:AVAudioFile! //AV audio file variable
    var audioEngine:AVAudioEngine! //audio engine variable
    var audioPlayerNode: AVAudioPlayerNode! //audio player node variable
    var stopTimer: Timer! // stop timer
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb, custom
    }
 
    //button outlets
    @IBOutlet weak var portrait: UIStackView!
    @IBOutlet weak var landscape: UIStackView!
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var customSpeed: UITextField!
    @IBOutlet weak var customPitch: UITextField!
    @IBOutlet weak var customSpeed2: UITextField!
    @IBOutlet weak var customPitch2: UITextField!
    
    
    //when the activity first launches
    override func viewDidLoad() {
        super.viewDidLoad()

        //set title name
        self.title = "Choose a Sound"
        
        //set up audio for the first time
        setupAudio();
        
    }
    
    //when the activity appers
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
        
        // Get device orientation
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        // change screen Layout screen
        if orientation.isPortrait {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.portrait.isHidden = false
                self.landscape.isHidden = true
            }
        } else if orientation.isLandscape {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.portrait.isHidden = true
                self.landscape.isHidden = false
            }
        }
        
        
    }
    
    //when user rotates the deviece
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Get device orientation
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        // change the Layout screen
        if orientation.isPortrait {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.portrait.isHidden = false
                self.landscape.isHidden = true
            }
        } else if orientation.isLandscape {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.portrait.isHidden = true
                self.landscape.isHidden = false
            }
        }
    }
    
    //when view disappear stop the audio
    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
    }
    
    //choose what sounds to play when some button is pressed
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        case .custom:
            customSound()
        }
        
        configureUI(.playing)
    }
    
    //play custom sound
    @IBAction func playCustomSound(_ sender: Any) {
        customSound()
    }
    
    //play custom sound
    @IBAction func playCustomSound2(_ sender: Any) {
        customSound2()
    }
    
    
    //set custom sound
    private func customSound(){
        var speed: Float = 1
        var pitch: Float = 0
        
        //read user input
        if let customSpeed = Float(self.customSpeed.text!),self.customSpeed.text != ""{
            speed = customSpeed
        }
        if let customPitch = Float(self.customPitch.text!),self.customPitch.text != ""{
            pitch = customPitch
        }
        
        //play custom sound
        playSound(rate: speed, pitch: pitch)
        
        //reset the text
        self.customSpeed.text = ""
        self.customPitch.text = ""
    }
    
    private func customSound2(){
        var speed: Float = 1
        var pitch: Float = 0
        
        //read user input
        if let customSpeed = Float(self.customSpeed2.text!),self.customSpeed2.text != ""{
            speed = customSpeed
        }
        if let customPitch = Float(self.customPitch2.text!),self.customPitch2.text != ""{
            pitch = customPitch
        }
        
        //play custom sound
        playSound(rate: speed, pitch: pitch)
        
        //reset the text
        self.customSpeed2.text = ""
        self.customPitch2.text = ""
    }
    
    //stop the audio when stop button pressed
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }

}
