//
//  EMF1Helper.swift
//  EMF Detector
//
//  Created by David Somen on 21/02/2016.
//  Copyright © 2016 Dodongdude. All rights reserved.
//

import CoreMotion

class EMF1Helper: NSObject, IEMFHelper
{
    private let motionManager = CMMotionManager()
    
    private var minMagnitude: Double = Double.infinity
    private var maxMagnitude: Double = 0
    
    var delegate: EMFHelperDelegate?
    
    override init()
    {
        super.init()
        
        resetRatio()
    }
    
    func start()
    {
        motionManager.startMagnetometerUpdatesToQueue(NSOperationQueue.currentQueue()!)
        {
            data, error in
            
            guard let data = data else { return }
            
            self.handleMagneticField(data.magneticField)
        }
    }
    
    func stop()
    {
        motionManager.stopMagnetometerUpdates()
    }
    
    func resetRatio()
    {
        minMagnitude = Double.infinity
        maxMagnitude = 0
    }
    
    private func handleMagneticField(field: CMMagneticField)
    {
        let magnitude = magnitude3D(field.x, field.y, field.z)
        
        minMagnitude = min(magnitude, minMagnitude)
        maxMagnitude = max(magnitude, maxMagnitude)
        
        let a = magnitude - minMagnitude
        let b = maxMagnitude - minMagnitude
        var c = a / b
        
        if c.isNaN { c = 0 }
        
        self.delegate?.strengthUpdated(c)
    }
    
    private func magnitude3D(x: Double, _ y: Double, _ z: Double) -> Double
    {
        return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
    }
}
