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
    }
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var overlayView: UIView!
    
    @IBAction func filterDoctor(sender: AnyObject) {
        updateFilter("doctor.png")
    }
    
    @IBAction func filterNone(sender: AnyObject) {
        updateFilter("transparent.png")
    }
    
    @IBAction func filterSuit(sender: AnyObject) {
        updateFilter("suit.png")
    }
    
    @IBAction func filterGamer(sender: AnyObject) {
        updateFilter("hoodie.png")
    }
    
    @IBAction func filterKid(sender: AnyObject) {
        updateFilter("kid.png")
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
        previewLayer?.frame = CGRect(x: 0, y: -50, width: CGRectGetWidth(bounds), height: CGRectGetHeight(bounds))
        videoView.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

