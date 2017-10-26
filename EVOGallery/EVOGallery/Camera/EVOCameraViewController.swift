//
//  EVOCameraViewController.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 24.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit
import AVFoundation

enum CameraFlashState: String {
    case auto = "stateAuto"
    case on = "stateOn"
    case off = "stateOff"
}

class EVOCameraViewController: UIViewController, EVOCameraFooterProtocol, EVOCameraHeaderProtocol {
    
    public var overlaysStyle = EVOCameraOverlaysStyle()
    public var headerView: EVOCameraHeaderView?
    public var footerView: EVOCameraFooterView?
    public let cameraFocusView = EVOCameraFocusView()
    
    fileprivate let captureSession = AVCaptureSession()
    fileprivate var captureInput: AVCaptureDeviceInput?
    fileprivate let captureOutput = AVCapturePhotoOutput()
    fileprivate var capturePreview: AVCaptureVideoPreviewLayer?
    fileprivate var flashState: CameraFlashState = .off
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        setupFocusView()
        setupOverlays()
    }
    
    override func viewDidLayoutSubviews() {
        self.cameraFocusView.frame = self.view.bounds
        
        if let header = self.headerView {
            header.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.overlaysStyle.headerSize.width,
                                  height: self.overlaysStyle.headerSize.height)
        }
        
        if let footer = self.footerView  {
            footer.frame = CGRect(x: 0,
                                  y: self.view.bounds.height - self.overlaysStyle.footerSize.height,
                                  width: self.overlaysStyle.footerSize.width,
                                  height: self.overlaysStyle.footerSize.height)
        }
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
    
    func setupOverlays() {
        self.headerView = EVOCameraHeaderView(with: self.overlaysStyle)
        self.headerView?.headerDelegate = self
        self.cameraFocusView.addSubview(self.headerView!)
        
        self.footerView = EVOCameraFooterView(with: self.overlaysStyle)
        self.footerView?.footerDelegate = self
        self.cameraFocusView.addSubview(self.footerView!)
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
    
    private func changeFlashState() {
        guard let device = getDevice(with: .back)  else {
            log(with: "No device found")
            
            return
        }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                switch self.flashState {
                case .auto:
                    device.torchMode = AVCaptureDevice.TorchMode.on
                    self.flashState = .on
                    break
                case .on:
                    device.torchMode = AVCaptureDevice.TorchMode.off
                    self.flashState = .off
                    break
                case .off:
                    device.torchMode = AVCaptureDevice.TorchMode.auto
                    self.flashState = .auto
                    break
                }
                
                self.headerView?.changeFlashImage(with: self.flashState)
                
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }

    }
    
    // MARK: EVOCameraHeaderProtocol
    func closeButtonPressed() {
        stopCaptureSession()
        dismiss(animated: true, completion: nil)
    }
    
    func flashButtonPressed() {
        changeFlashState()
    }
    
    func switchCameraButtonPressed() {
        
    }
    
    // MARK: EVOCameraFooterProtocol
    func galleryButtonPressed() {
        
    }
    
    func captureButtonPressed() {
        
    }
}
