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

protocol EVOCameraViewControllerDelegate: class {
    func cameraDidCapture(image: EVOCollectionDTO)
    func cameraDidCanceled()
}

class EVOCameraViewController: UIViewController, EVOCameraFooterProtocol, EVOCameraHeaderProtocol, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EVOCroperViewControllerDelegate {

    public var overlaysStyle = EVOOverlaysStyle()
    public var headerView: EVOCameraHeaderView?
    public var footerView: EVOCameraFooterView?
    public let cameraFocusView = EVOCameraFocusView()
    public weak var cameraDelegate: EVOCameraViewControllerDelegate?
    
    private var captureSession: AVCaptureSession?
    private var captureInput: AVCaptureDeviceInput?
    private var captureOutput: AVCapturePhotoOutput?
    private var capturePreview: AVCaptureVideoPreviewLayer?
    private var flashState: FlashState = .auto
    private var setupState: SessionSetupState = .success
    private var captureDevicePosition = AVCaptureDevice.Position.back
    
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
            startCaptureSession()
        }
        
        if let navigationController = self.navigationController {
            navigationController.isNavigationBarHidden = true
        }
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if self.setupState == .success {
            stopCaptureSession()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.overlaysStyle.statusBarStyle
    }
    
    // MARK: Setups
    private func checkAutorizationStatus() {
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
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handle))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupFocusView() {
        self.cameraFocusView.removeFromSuperview()
        
        self.view.addSubview(self.cameraFocusView)
        self.cameraFocusView.bringSubview(toFront: self.view)
    }
    
    private func setupSession() {
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
    
    private func setupPreviewLayer() {
            switch self.setupState {
            case .success:
                guard let captureSession = self.captureSession else {
                    showAlert(with: nil,
                              message: NSLocalizedString("camera.device.error", comment: ""),
                              actionButtons: nil)
                    return
                }
                
                self.capturePreview?.removeFromSuperlayer()
            
                self.capturePreview = AVCaptureVideoPreviewLayer(session: captureSession)
                self.capturePreview!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.capturePreview!.frame = self.view.bounds
                self.view.layer.addSublayer(self.capturePreview!)
                
            case .notAuthorized:
                let ok =  UIAlertAction(title: NSLocalizedString("common.ok", comment: ""),
                                        style: .cancel,
                                        handler: nil)
                
                let settings = UIAlertAction(title: NSLocalizedString("common.settings", comment: ""),
                                             style: .default,
                                             handler: { _ in
                                                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                                                
                })
                
                showAlert(with: nil,
                          message: NSLocalizedString("camera.access.error", comment: ""),
                          actionButtons: [ok, settings])
            case .configurationFailed:
                showAlert(with: NSLocalizedString("common.error", comment: ""),
                          message: NSLocalizedString("common.error.notice", comment: ""),
                          actionButtons: nil)
            }
    }
    
    private func setupOverlays() {
        self.headerView = EVOCameraHeaderView(with: self.overlaysStyle)
        self.headerView?.headerDelegate = self
        self.cameraFocusView.addSubview(self.headerView!)
        
        self.footerView = EVOCameraFooterView(with: self.overlaysStyle)
        self.footerView?.footerDelegate = self
        self.cameraFocusView.addSubview(self.footerView!)
    }
    
    private func getDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        var device: AVCaptureDevice?
        
        if let dualCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInDualCamera, for: AVMediaType.video, position: position) {
            device = dualCameraDevice
        } else if let wideCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: position) {
            device = wideCameraDevice
        }
        
        return device
    }
    
    // MARK: Actions
    private func openCropController(with image: UIImage!) {
        let dto = EVOCollectionDTO()
        dto.image = image
        
        let cropController = EVOCroperViewController()
        cropController.sourceImage = dto
        cropController.croperDelegate = self
        
        self.navigationController?.pushViewController(cropController, animated: false)
    }
    
    private func startCaptureSession() {
        guard let captureSession = self.captureSession else {
            return
        }
        
        if (!captureSession.isRunning) {
            captureSession.startRunning()
        }
    }
    
    private func stopCaptureSession() {
        guard let captureSession = self.captureSession else {
            return
        }
        
        if (captureSession.isRunning) {
            captureSession.stopRunning()
        }
    }
    
    private func log(with text: String) {
        print(text)
    }
    
    @objc private func handle(tapGesture: UITapGestureRecognizer) {
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
    
    private func changeFlashState() {
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
                log(with: error.localizedDescription)
            }
        }
    }
    
    private func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()

        if !photoSettings.availablePreviewPhotoPixelFormatTypes.isEmpty {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.availablePreviewPhotoPixelFormatTypes.first!]
        }
        
        guard let output = self.captureOutput else {
            log(with: "No capture output")
            return
        }
        
        output.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @available (iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()

        if let data = imageData as CFData? {
            let dataProvider = CGDataProvider(data: data)
            let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.absoluteColorimetric)
            let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
            
            openCropController(with: image)
        }
    }

    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            log(with: error.localizedDescription)
        } else {
            if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
                
                if let image = UIImage(data: dataImage) {
                   openCropController(with: image)
                }
            }
        }
    }
    
    private func close(animated: Bool) {
        if let _ = self.navigationController {
            self.navigationController?.popViewController(animated: animated)
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }
    
    private func switchCamera() {
        self.captureDevicePosition = self.captureDevicePosition == .back ? .front : .back
        
        stopCaptureSession()
        setupSession()
        setupPreviewLayer()
        setupFocusView()
        startCaptureSession()
    }
    
    private func openGallery() {
        let gallery = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            gallery.delegate = self
            gallery.sourceType = .savedPhotosAlbum;
            gallery.allowsEditing = false
            
            present(gallery, animated: true, completion: nil)
        } else {
            log(with: "Photos album is not available")
        }
    }
    
    func showAlert(with title: String?, message: String?, actionButtons: [UIAlertAction]?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actions = actionButtons {
            actions.forEach({ (action) in
                alertController.addAction(action)
            })
        } else {
            let ok = UIAlertAction(title: NSLocalizedString("common.ok", comment: ""), style: .default, handler: nil)
            alertController.addAction(ok)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: EVOCameraHeaderProtocol
    func closeButtonPressed() {
        close(animated: true)
    }
    
    func flashButtonPressed() {
        changeFlashState()
    }
    
    func switchCameraButtonPressed() {
        switchCamera()
    }
    
    // MARK: EVOCameraFooterProtocol
    func captureButtonPressed() {
        capturePhoto()
    }
    
    func galleryButtonPressed() {
        openGallery()
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        picker.dismiss(animated: true) { [weak self] in
            self?.openCropController(with: image)
        }
    }
    
    // MARK: EVOCroperViewControllerDelegate
    func croperDidCrop(image: EVOCollectionDTO) {
        self.cameraDelegate?.cameraDidCapture(image: image)
        close(animated: true)
    }
    
    func croperDidCanceled() {
        self.cameraDelegate?.cameraDidCanceled()
    }
}
