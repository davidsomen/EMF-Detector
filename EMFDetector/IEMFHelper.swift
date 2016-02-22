//
//  IEMFHelper.swift
//  EMF Detector
//
//  Created by David Somen on 21/02/2016.
//  Copyright © 2016 Dodongdude. All rights reserved.
//

protocol EMFHelperDelegate
{
    func strengthUpdated(strength: Double)
}

protocol IEMFHelper
{
    var delegate: EMFHelperDelegate? { get set }
    
    func start()
    func stop()
}
