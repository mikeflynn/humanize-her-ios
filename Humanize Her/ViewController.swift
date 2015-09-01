//
//  ViewController.swift
//  Humanize Her
//
//  Created by Mike Flynn on 8/28/15.
//  Copyright (c) 2015 That Mike Flynn. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
        if captureDevice != nil {
            beginVideoSession()
        }
        
        drawFilters()
    }
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var filterView: UIScrollView!
    
    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            // Save screenshot to Photo Roll
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            // Cancelled.
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func filterDoctor(sender: AnyObject) {
        updateFilter("doctor.png")
    }
    
    func filterNone(sender: AnyObject) {
        updateFilter("transparent.png")
    }
    
    func filterSuit(sender: AnyObject) {
        updateFilter("suit.png")
    }
    
    func filterGamer(sender: AnyObject) {
        updateFilter("hoodie.png")
    }
    
    func filterKid(sender: AnyObject) {
        updateFilter("kid.png")
    }
    
    func filterTest(sender: AnyObject) {
        updateFilter("kid.png")
    }
    
    func drawFilters() {
        let filters: [[String:String]] = [
            ["icon": "icon_help.png", "action": "filterTest:"],
            ["icon": "icon_female.png", "action": "filterNone:"],
            ["icon": "icon_doctor.png", "action": "filterDoctor:"],
            ["icon": "icon_briefcase.png", "action": "filterSuit:"],
            ["icon": "icon_gaming.png", "action": "filterGamer:"],
            ["icon": "icon_baby.png", "action": "filterKid:"],
        ]
        
        filterView.contentSize = CGSizeMake(5 + (102 * CGFloat(filters.count)), filterView.contentSize.height)
        filterView.userInteractionEnabled = true
        
        
        let containerView = UIView()
        containerView.frame = CGRectMake(0, 0, filterView.contentSize.width + 10, filterView.contentSize.height + 100);
        containerView.userInteractionEnabled = true
        //containerView.backgroundColor = UIColor.brownColor()
        filterView.addSubview(containerView)
        
        var x:Int = 0
        for filter in filters {
            let btnImg = UIImage(named: filter["icon"]!) as UIImage?
            
            let btn = UIButton()
            btn.frame = CGRect(x: 5 + (102 * x), y: 10, width: 82, height: 50)
            btn.userInteractionEnabled = true
            btn.setImage(btnImg, forState: .Normal)
            //btn.setImage(UIImage(named: "icon_help.png"), forState: UIControlState.Highlighted)
            btn.tag = x + 100
            btn.addTarget(self, action: Selector(filter["action"]!), forControlEvents: UIControlEvents.TouchUpInside)
            containerView.addSubview(btn)
            x++
        }

        filterView.setContentOffset(CGPointMake(107.0, 0.0), animated: true)
    }
    
    func updateFilter(assetName: String) {
        let bounds:CGRect = overlayView.bounds
        
        for view in overlayView.subviews{
            view.removeFromSuperview()
        }
        
        let image = UIImage(named: assetName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .ScaleAspectFill
        imageView.frame = CGRect(x: 0, y: 56, width: CGRectGetWidth(bounds), height: CGRectGetHeight(bounds))
        overlayView.addSubview(imageView)
    }
    
    func configureDevice() {
        if let device = captureDevice {
            try! device.lockForConfiguration()
            device.focusMode = .AutoFocus
            device.unlockForConfiguration()
        }
    }
    
    func beginVideoSession() {
        configureDevice()
        
        var err : NSError? = nil
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            captureSession.addInput(input)
        } catch let error as NSError {
            err = error
        }
        
        if err != nil {
            print("error: \(err?.localizedDescription)")
        }
        
        let bounds:CGRect = self.view.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect; // AVLayerVideoGravityResizeAspectFill
        //previewLayer?.bounds = bounds
        //previewLayer?.frame = self.view.frame
        previewLayer?.frame = CGRect(x: 0, y: -70, width: CGRectGetWidth(bounds), height: CGRectGetHeight(bounds))
        videoView.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

