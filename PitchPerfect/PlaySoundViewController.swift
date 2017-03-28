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
 
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
 


    
    @IBOutlet weak var portrait: UIStackView!
    @IBOutlet weak var landscape: UIStackView!
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Choose a Sound"
        
        // Do any additional setup after loading the view.
        setupAudio();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
        
        // Get device orientation
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        // Layout screen
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Get device orientation
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        // Layout screen
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
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
    }
    
    
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
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }

}
