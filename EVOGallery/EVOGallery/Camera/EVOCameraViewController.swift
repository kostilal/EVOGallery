//
//  EVOCameraViewController.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 24.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit
import AVFoundation

enum CameraFlashState: Int {
    case auto
    case on
    case off
}

class EVOCameraViewController: UIViewController {
    public var headerView: UIView?
    public var footerView: UIView?
    public let cameraFocusView = EVOCameraFocusView()
    
    fileprivate let captureSession = AVCaptureSession()
    fileprivate var captureInput: AVCaptureDeviceInput?
    fileprivate let captureOutput = AVCapturePhotoOutput()
    fileprivate var capturePreview: AVCaptureVideoPreviewLayer?
    fileprivate var flashState: CameraFlashState = .auto
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        setupFocusView()
    }
    
    override func viewDidLayoutSubviews() {
        self.cameraFocusView.frame = self.view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Setups
    fileprivate func setupFocusView() {
        
        self.view.addSubview(self.cameraFocusView)
        self.cameraFocusView.bringSubview(toFront: self.view)
    }
    
    fileprivate func setupCamera() {
        guard let device = getDevice(with: .back)  else {
            log(with: "No device found")
            
            return
        }
        
        do {
            try self.captureInput = AVCaptureDeviceInput(device: device)
        } catch {
            log(with: error.localizedDescription)
        }
        
        self.captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        if self.captureSession.canAddInput(self.captureInput!) {
            self.captureSession.addInput(self.captureInput!)
            
            if self.captureSession.canAddOutput(self.captureOutput) {
                self.captureSession.addOutput(self.captureOutput)
                
                self.capturePreview = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.capturePreview!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.capturePreview!.frame = self.view.bounds
                self.view.layer.addSublayer(self.capturePreview!)
            } else {
                log(with: "Can't add capture output")
            }
        } else {
            log(with: "Can't add capture input")
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handle))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        startCaptureSession()
    }
    
    fileprivate func getDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: position)
        
        return device
    }
    
    // MARK: Actions
    open func startCaptureSession() {
        self.captureSession.startRunning()
    }
    
    open func stopCaptureSession() {
        self.captureSession.stopRunning()
    }
    
    fileprivate func log(with text: String) {
        print(text)
    }
    
    @objc func handle(tapGesture: UITapGestureRecognizer) {
        let tapPoint = tapGesture.location(in: self.cameraFocusView)
        let focusPoint = CGPoint(x: tapPoint.x / self.view.bounds.size.width, y: tapPoint.y / self.view.bounds.size.height)
        
        guard let device = self.captureInput?.device else {
            log(with: "No device found")
            
            return
        }
        
        do {
            try device.lockForConfiguration()
            device.focusPointOfInterest = focusPoint
            device.focusMode = .autoFocus
            device.unlockForConfiguration()
            
            self.cameraFocusView.setFocus(point: tapPoint)
        } catch {
            log(with: "Can't lock the device")
        }
    }
}
