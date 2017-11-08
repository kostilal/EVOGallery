//
//  EVOCameraHeaderView.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 26.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

protocol EVOCameraHeaderProtocol: EVOOverlayViewDelegate {
    func flashButtonPressed()
    func switchCameraButtonPressed()
}

class EVOCameraHeaderView: EVOOverlayView {
    public weak var headerDelegate: EVOCameraHeaderProtocol?
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.closeButtonImage, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        
        return button
    }()
    
    lazy var switchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.switchButtonImage, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        
        return button
    }()
    
    lazy var flashButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.flashButtonImages[FlashState.auto.rawValue], for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        
        return button
    }()
    
    lazy var navigationView: UIView = {
        let navView = UIView()
        navView.backgroundColor = self.overlayStyle.headerBackgroundColor
        
        return navView
    }()
    
    override func setupUI() {
        self.addSubview(self.navigationView)
        self.navigationView.addSubview(self.backButton)
        self.navigationView.addSubview(self.switchButton)
        self.navigationView.addSubview(self.flashButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.navigationView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.overlayStyle.headerSize.width,
                                           height: self.overlayStyle.headerSize.height)
        
        self.backButton.frame = CGRect(x: 0,
                                       y: self.overlayStyle.headerSize.height - self.overlayStyle.buttonMargin - self.overlayStyle.controlButtonsSize.height,
                                       width: self.overlayStyle.controlButtonsSize.width,
                                       height: self.overlayStyle.controlButtonsSize.height)

        self.flashButton.frame = CGRect(x: self.overlayStyle.headerSize.width - self.overlayStyle.buttonMargin - self.overlayStyle.controlButtonsSize.width,
                                        y: self.overlayStyle.headerSize.height - self.overlayStyle.buttonMargin - self.overlayStyle.controlButtonsSize.height,
                                        width: self.overlayStyle.controlButtonsSize.width,
                                        height: self.overlayStyle.controlButtonsSize.height)
        
        self.switchButton.frame = CGRect(x: self.overlayStyle.headerSize.width - self.overlayStyle.buttonMargin - (self.overlayStyle.controlButtonsSize.width * 2) - self.overlayStyle.buttonMargin * 2,
                                         y: self.overlayStyle.headerSize.height - self.overlayStyle.buttonMargin - self.overlayStyle.controlButtonsSize.height,
                                         width: self.overlayStyle.controlButtonsSize.width,
                                         height: self.overlayStyle.controlButtonsSize.height)
    }
    
    public func changeFlashImage(with state: FlashState) {
        self.flashButton.setImage(self.overlayStyle.flashButtonImages[state.rawValue], for: .normal)
    }
    
    override func buttonPressed(sender: UIButton) {
        super.buttonPressed(sender: sender)
        
        if sender == self.backButton {
            self.headerDelegate?.closeButtonPressed()
        } else if sender == self.switchButton {
            self.headerDelegate?.switchCameraButtonPressed()
        } else {
            self.headerDelegate?.flashButtonPressed()
        }
    }
}
