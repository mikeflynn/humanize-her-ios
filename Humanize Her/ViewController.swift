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
    
    var filterCount : Int = 0
    var filterLevel : Int = 0
    
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
        
        let initialFilters: [[String:String]] = [
            ["icon": "icon_help.png", "action": "filterTest:"],
            ["icon": "icon_female.png", "action": "filterNone:"],
            ["icon": "icon_doctor.png", "action": "filterDoctor:"],
            ["icon": "icon_briefcase.png", "action": "filterSuit:"],
            ["icon": "icon_gaming.png", "action": "filterGamer:"],
            ["icon": "icon_baby.png", "action": "filterKid:"],
        ]
        
        drawFilters(initialFilters)
    }
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var filterView: UIScrollView!
    
    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        //let photoAction = UIAlertAction(title: "Save Photo", style: .Default, handler: {
        //    (alert: UIAlertAction!) -> Void in
        //
        //    self.screenShotMethod()
        //    self.makeAlert("Humanize Her", msg: "Photo saved for future humanizing.", button: "Thanks")
        //})

        let ignoreAction = UIAlertAction(title: "Continue Ignoring Her", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in

            if self.filterLevel == 0 {
                let moreFilters: [[String:String]] = [
                    ["icon": "icon_help.png", "action": "filterTest:"],
                ]
            
                self.drawFilters(moreFilters)
            
                self.makeAlert("Level 2", msg: "More super manly filters added.", button: "Humanize Her!")
            } else if self.filterLevel == 1 {
                let moreFilters: [[String:String]] = [
                    ["icon": "icon_help.png", "action": "filterTest:"],
                ]
                
                self.drawFilters(moreFilters)
                
                self.makeAlert("Level 3", msg: "We're maxed out here.", button: "Humanize Her!")
            } else {
                self.makeAlert("Maximum Level Reached", msg: "Nowhere else to go. I guess you're just an asshole.", button: "Whatever.")
            }
            
            self.filterLevel++
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            // Cancelled.
        })
        
        //optionMenu.addAction(photoAction)
        optionMenu.addAction(ignoreAction)
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
    
    func drawFilters(filters: [[String:String]]) {
        
        let startCount = filterCount
        filterCount = filterCount + filters.count
        
        filterView.contentSize = CGSizeMake(5 + (102 * CGFloat(filterCount)), filterView.contentSize.height)
        filterView.userInteractionEnabled = true
        
        var containerView: UIView = UIView()
        if filterView.subviews.count == 0 {
            containerView.userInteractionEnabled = true
            //containerView.backgroundColor = UIColor.brownColor()
            filterView.addSubview(containerView)
        } else {
            containerView = filterView.subviews[0]
        }
        
        containerView.frame = CGRectMake(0, 0, filterView.contentSize.width + 10, filterView.contentSize.height + 100);
        
        var x:Int = startCount
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
    
    func makeAlert(title: String, msg: String, button: String) {
        let alert8 = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert8.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert8, animated: true, completion: nil)
    }
    
    func screenShotMethod() {
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
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

