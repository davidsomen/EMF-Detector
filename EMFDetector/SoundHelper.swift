//
//  SoundHelper.swift
//  EMFDetector
//
//  Created by David Somen on 21/02/2016.
//  Copyright © 2016 Dodongdude. All rights reserved.
//

import UIKit
import AudioKit

private enum SoundHelperType
{
    case Sine
    case Square
}

class SoundHelper: NSObject, EZOutputDataSource
{
    private let twoPi = Float(2.0 * Double.pi)
    private let kSampleRate: Float = 44100
    private let kMaxFrequency: Float = 880
    private let kMinFrequency: Float = 0
    private let type: SoundHelperType = .Sine
    private var frequency: Float = 0
    private var amplitude: Float = 0.8
    private var theta: Float = 0
    
    private var output: EZOutput!
    
    var level: Float = 0
    {
        didSet
        {
            frequency = (level * (kMaxFrequency - kMinFrequency)) + kMinFrequency
        }
    }
    
    override init()
    {
        super.init()
        
        setupOutput()
    }
    
    private func setupOutput()
    {
        let inputFormat = EZAudioUtilities.monoFloatFormat(withSampleRate: kSampleRate)
        output = EZOutput(dataSource: self, inputFormat: inputFormat)
    }
    
    func start()
    {
        output.startPlayback()
    }
    
    func stop()
    {
        output.stopPlayback()
    }
    
    func output(_ output: EZOutput!, shouldFill audioBufferList: UnsafeMutablePointer<AudioBufferList>!, withNumberOfFrames frames: UInt32, timestamp: UnsafePointer<AudioTimeStamp>!) -> OSStatus
    {
        let abl = UnsafeMutableAudioBufferListPointer(audioBufferList)!
        let buffer = abl.first!.mData
        
        var theta = self.theta
        let thetaIncrement = twoPi * frequency / kSampleRate
        
        let pbuffer = buffer!.assumingMemoryBound(to: Float.self)
        
        //let pbuffer = UnsafeMutablePointer<Float>(buffer)
        let frames = Int(frames)
        
        if type == .Sine
        {
            for frame in 0..<frames
            {
                pbuffer[Int(frame)] = amplitude * sin(theta)
                theta += thetaIncrement
                if theta > twoPi
                {
                    theta -= twoPi
                }
                
                self.theta = theta
            }
        }
        else if type == .Square
        {
            for frame in 0..<frames
            {
                pbuffer[Int(frame)] = self.amplitude * EZAudioUtilities.sgn(theta)
                theta += thetaIncrement
                if theta > twoPi
                {
                    theta -= twoPi * 2
                }
            }
            
            self.theta = theta
        }
        else
        {
            let bufferByteSize = abl.first!.mDataByteSize
            
            memset(buffer, 0, Int(bufferByteSize))
        }
        
        return 0
    }
}
