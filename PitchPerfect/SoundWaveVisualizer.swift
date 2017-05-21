//
//  SoundWaveVisualizer.swift
//  PitchPerfect

/**
  This class visualize the sound that is being recorded
  This library was freely availabe to use on Github
 **/

import Foundation
import UIKit

class SoundWaveVisualizer: UIView {
    
    var waveColor = UIColor.white //sound color
    var frequency = 1.5 //frequency of the wave
    var amplitude =  1.0 //amplitude of the wave
    var idleAmplitude = 0.0 //idleamplitude of the wave
    var numberOfWaves = 4 //number of waves
    var phaseShift = -0.15 //phase shift
    var density: CGFloat = 0.5 //wave density
    var primaryLineWidth: CGFloat = 0.3 //wave primary line width
    var secondaryLineWidth: CGFloat = 1.0 //wave secondary line width
    
    var phase = 0.0
    
    func updateWithPowerLevel(_ level: Float) {
        let level = Double(level)
        
        phase = phase + phaseShift
        amplitude = fmax(level, idleAmplitude)
        
        setNeedsDisplay()
    }
    
    //draw wave
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.clear(self.bounds)
        
        backgroundColor?.set()
        context?.fill(rect)
        
        for i in 0..<numberOfWaves {
            let lineContext = UIGraphicsGetCurrentContext()
            
            lineContext?.setLineWidth((i == 0) ? 2.0 : 1.0)
            
            let halfHeight = rect.height / 2
            let width = rect.width
            let midX = width / 2
            
            let maxAmplitude = halfHeight - 1.0 // 2 corresponds to twice the stroke width
            
            // Progress is a value between 1.0 and -0.5, determined by the current wave idx, which is used to alter the wave's amplitude.
            let progress = 1.0 - Double(i) / Double(numberOfWaves)
            let normalizedAmplitude = (1.5 * progress - 0.5) * amplitude
            
            let right = (progress / 3.0 * 2.0) + (1.0 / 3.0)
            let colorMultiplier = min(1.0, right)
            waveColor.withAlphaComponent(CGFloat(colorMultiplier)).set()
            
            var x: CGFloat = 0
            while x < width {
                
                let scaling = -pow(1 / midX * (x - midX), 2) + 1
                
                let y = scaling * maxAmplitude * CGFloat( normalizedAmplitude * sin(2 * Double.pi * Double((x / width)) * frequency + phase) ) + halfHeight
                
                (x == 0) ? lineContext?.move(to: CGPoint(x: x, y: y)) : lineContext?.addLine(to: CGPoint(x: x, y: y));
                
                x = x + density
            }
            lineContext?.strokePath()
        }
        
    }
}

