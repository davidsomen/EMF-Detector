//
//  ViewController.swift
//  EMF Detector
//
//  Created by David Somen on 21/02/2016.
//  Copyright © 2016 Dodongdude. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EMFHelperDelegate
{
    @IBOutlet weak var levelLabel: UILabel!
    
    private var emfHelper: EMF1Helper
    private var soundHelper: SoundHelper
    
    required init?(coder aDecoder: NSCoder)
    {
        emfHelper = EMF1Helper()
        soundHelper = SoundHelper()
        
        super.init(coder: aDecoder)
        
        emfHelper.delegate = self
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        emfHelper.start()
        soundHelper.start()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        emfHelper.stop()
        soundHelper.stop()
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    func strengthUpdated(strength: Double)
    {
        levelLabel.text = String(format:"%.3f", strength)
        
        view.backgroundColor = UIColor(red: CGFloat(strength), green: 0, blue: 0, alpha: 1)
        
        soundHelper.level = Float(strength)
    }
    
    @IBAction func resetRatioButton(sender: AnyObject)
    {
        emfHelper.resetRatio()
    }
}