//
//  EMF2Helper.swift
//  EMF Detector
//
//  Created by David Somen on 21/02/2016.
//  Copyright © 2016 Dodongdude. All rights reserved.
//

import CoreLocation

class EMF2Helper: NSObject, CLLocationManagerDelegate
{
    private let locationManager = CLLocationManager()
    
    var delegate: EMFHelperDelegate?
    
    override init()
    {
        super.init()
        
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.delegate = self
    }
    
    func start()
    {
        locationManager.startUpdatingHeading()
    }
    
    func stop()
    {
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        let magnitude = sqrt(pow(newHeading.x, 2) + pow(newHeading.y, 2) + pow(newHeading.z, 2))
        
        delegate?.strengthUpdated(strength: magnitude)
    }
}
