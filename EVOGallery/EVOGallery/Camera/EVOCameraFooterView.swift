//
//  EVOCameraFooterView.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 26.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

protocol EVOCameraFooterProtocol: EVOOverlayViewDelegate {
    func galleryButtonPressed()
    func captureButtonPressed()
}

class EVOCameraFooterView: EVOOverlayView {
    public weak var footerDelegate: EVOCameraFooterProtocol?
    
    lazy var galleryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.galleryButtonImage, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        
        return button
    }()
    
    lazy var captureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.captureButtonImage, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.backgroundColor = self.overlayStyle.controlButtonsTintColor
        button.tintColor = self.overlayStyle.captureButtonTintColor
        
        return button
    }()

    lazy var bottomView: UIView = {
        let navView = UIView()
        navView.backgroundColor = self.overlayStyle.footerBackgroundColor
        
        return navView
    }()

    override func setupUI() {
        self.addSubview(self.bottomView)
        self.bottomView.addSubview(self.galleryButton)
        self.bottomView.addSubview(self.captureButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.galleryButton.frame = CGRect(x: self.overlayStyle.footerSize.width / 5,
                                          y: self.overlayStyle.footerSize.height/2 - self.overlayStyle.controlButtonsSize.height/2,
                                          width: self.overlayStyle.controlButtonsSize.width,
                                          height: self.overlayStyle.controlButtonsSize.height)
        
        self.captureButton.frame = CGRect(x: self.overlayStyle.footerSize.width/2 - self.overlayStyle.captureButtonsSize.width/2,
                                          y: self.overlayStyle.footerSize.height/2 - self.overlayStyle.captureButtonsSize.height/2,
                                          width: self.overlayStyle.captureButtonsSize.width,
                                          height: self.overlayStyle.captureButtonsSize.height)
        
        self.bottomView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.overlayStyle.footerSize.width,
                                       height: self.overlayStyle.footerSize.height)
        
        self.captureButton.layer.cornerRadius = self.overlayStyle.captureButtonsSize.width/2
    }
    
    override func buttonPressed(sender: UIButton) {
        super.buttonPressed(sender: sender)
        
        if sender == self.galleryButton {
            self.footerDelegate?.galleryButtonPressed()
        } else {
            self.footerDelegate?.captureButtonPressed()
        }
    }
}
