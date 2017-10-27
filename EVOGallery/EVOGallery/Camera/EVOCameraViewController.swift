//
//  EVOCameraViewController.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 24.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit
import AVFoundation

enum FlashState: String {
    case auto = "stateAuto"
    case on = "stateOn"
    case off = "stateOff"
}

enum SessionSetupState {
    case success
    case notAuthorized
    case configurationFailed
}

class EVOCameraViewController: UIViewController, EVOCameraFooterProtocol, EVOCameraHeaderProtocol, AVCapturePhotoCaptureDelegate {
    
    public var overlaysStyle = EVOCameraOverlaysStyle()
    public var headerView: EVOCameraHeaderView?
    public var footerView: EVOCameraFooterView?
    public let cameraFocusView = EVOCameraFocusView()
    public var previewImageView = UIImageView()
    
    fileprivate var captureSession: AVCaptureSession?
    fileprivate var captureInput: AVCaptureDeviceInput?
    fileprivate var captureOutput: AVCapturePhotoOutput?
    fileprivate var capturePreview: AVCaptureVideoPreviewLayer?
    fileprivate var flashState: FlashState = .auto
    fileprivate var setupState: SessionSetupState = .success
    fileprivate var captureDevicePosition = AVCaptureDevice.Position.back
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAutorizationStatus()
        
        setupSession()
        setupPreviewLayer()
        setupFocusView()
        setupOverlays()
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.setupState == .success {
            self.startCaptureSession()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if self.setupState == .success {
            self.stopCaptureSession()
        }
    
        super.viewWillDisappear(animated)
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
        
        self.previewImageView.frame = self.cameraFocusView.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Setups
    fileprivate func checkAutorizationStatus() {
        let autorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch autorizationStatus {
        case .authorized:
            // The user has previously granted access to the camera.
            break
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] granted in
                if !granted {
                    self.setupState = .notAuthorized
                }
            })
        default:
            self.setupState = .notAuthorized
        }
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handle))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    fileprivate func setupFocusView() {
        self.cameraFocusView.removeFromSuperview()
        
        self.view.addSubview(self.cameraFocusView)
        self.cameraFocusView.bringSubview(toFront: self.view)
    }
    
    fileprivate func setupSession() {
        guard let device = getDevice(with: self.captureDevicePosition)  else {
            log(with: "No device found")
            return
        }
        
        self.captureSession = AVCaptureSession()
        self.captureOutput = AVCapturePhotoOutput()

        self.captureSession!.beginConfiguration()
        self.captureSession!.sessionPreset = AVCaptureSession.Preset.photo
        
        do {
            try self.captureInput = AVCaptureDeviceInput(device: device)
            
            if self.captureSession!.canAddInput(self.captureInput!) {
                self.captureSession!.addInput(self.captureInput!)
            } else {
                log(with: "Can't add capture input")
                self.setupState = .configurationFailed
                self.captureSession!.commitConfiguration()
            }
        } catch {
            log(with: error.localizedDescription)
            self.setupState = .configurationFailed
            self.captureSession!.commitConfiguration()
        }
        
        if self.captureSession!.canAddOutput(self.captureOutput!) {
            self.captureSession!.addOutput(self.captureOutput!)
            
            self.captureOutput!.isHighResolutionCaptureEnabled = true
        } else {
            log(with: "Can't add capture output")
            self.setupState = .configurationFailed
            self.captureSession!.commitConfiguration()
        }
        
        self.captureSession!.commitConfiguration()
    }
    
    func setupPreviewLayer() {
            switch self.setupState {
            case .success:
                    self.capturePreview?.removeFromSuperlayer()
                
                    self.capturePreview = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                    self.capturePreview!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.capturePreview!.frame = self.view.bounds
                    self.view.layer.addSublayer(self.capturePreview!)
                
            case .notAuthorized:
                
                    let changePrivacySetting = "AVCam doesn't have permission to use the camera, please change privacy settings"
                    let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
                    let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                            style: .`default`,
                                                            handler: { _ in
                                                                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                
                
            case .configurationFailed:
                
                    let alertMsg = "Alert message when something goes wrong during capture session configuration"
                    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                    let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                
            }
    }
    
    func setupOverlays() {
        self.headerView = EVOCameraHeaderView(with: self.overlaysStyle)
        self.headerView?.headerDelegate = self
        self.cameraFocusView.addSubview(self.headerView!)
        
        self.footerView = EVOCameraFooterView(with: self.overlaysStyle)
        self.footerView?.footerDelegate = self
        self.cameraFocusView.addSubview(self.footerView!)
        
        self.cameraFocusView.addSubview(self.previewImageView)
        self.previewImageView.isHidden = true
    }
    
    fileprivate func getDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        var device: AVCaptureDevice?
        
        if let dualCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInDualCamera, for: AVMediaType.video, position: position) {
            device = dualCameraDevice
        } else if let wideCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: position) {
            device = wideCameraDevice
        }
        
        return device
    }
    
    // MARK: Actions
    fileprivate func startCaptureSession() {
        if (!self.captureSession!.isRunning) {
            self.captureSession!.startRunning()
        }
    }
    
    fileprivate func stopCaptureSession() {
        if (self.captureSession!.isRunning) {
            self.captureSession!.stopRunning()
        }
    }
    
    fileprivate func log(with text: String) {
        print(text)
    }
    
    @objc fileprivate func handle(tapGesture: UITapGestureRecognizer) {
        let tapPoint = tapGesture.location(in: self.cameraFocusView)
        let focusPoint = CGPoint(x: tapPoint.x / self.view.bounds.size.width, y: tapPoint.y / self.view.bounds.size.height)
        
        guard let device = self.captureInput?.device else {
            log(with: "No device found")
            return
        }
        
        if device.isFocusPointOfInterestSupported {
            do {
                try device.lockForConfiguration()
                device.focusPointOfInterest = focusPoint
                device.focusMode = .autoFocus
                device.unlockForConfiguration()
                
                self.cameraFocusView.setFocus(point: tapPoint)
            } catch {
                log(with: "Can't lock the device")
            }
        } else {
            log(with: "Focus not suported on the device")
        }
    }
    
    fileprivate func changeFlashState() {
        guard let device = getDevice(with: self.captureDevicePosition)  else {
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
    
    fileprivate func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()

        if !photoSettings.availablePreviewPhotoPixelFormatTypes.isEmpty {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.availablePreviewPhotoPixelFormatTypes.first!]
        }
        self.captureOutput!.capturePhoto(with: photoSettings, delegate: self)
    }
    
//    @available (iOS 11.0, *)
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        let imageData = photo.fileDataRepresentation()
//
//        if let data = imageData as CFData? {
//            let dataProvider = CGDataProvider(data: data)
//            let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.absoluteColorimetric)
//            let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
//
//            self.previewImageView.isHidden = false
//            self.previewImageView.contentMode = .scaleAspectFill
//            self.previewImageView.image = image
//        }
//    }

    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            log(with: error.localizedDescription)
        } else {
            if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
                
                if let image = UIImage(data: dataImage) {
                    self.previewImageView.isHidden = false
                    self.previewImageView.contentMode = .scaleAspectFill
                    self.previewImageView.image = image
                }
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
        self.captureDevicePosition = self.captureDevicePosition == .back ? .front : .back
        
        stopCaptureSession()
        setupSession()
        setupPreviewLayer()
        setupFocusView()
        startCaptureSession()
    }
    
    // MARK: EVOCameraFooterProtocol
    func galleryButtonPressed() {
        
    }
    
    func captureButtonPressed() {
        capturePhoto()
    }
}
