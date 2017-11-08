//
//  EVOCropperFooterView.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 06.11.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

protocol EVOCroperFooterDelegate: EVOOverlayViewDelegate {
    func gridButtonPressed()
    func cropButtonPressed()
}

class EVOCroperFooterView: EVOOverlayView {
    public weak var footerDelegate: EVOCroperFooterDelegate?
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.gridButtonImage, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        
        return button
    }()
    
    lazy var cropButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.cropButtonImage, for: .normal)
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
        self.bottomView.addSubview(self.gridButton)
        self.bottomView.addSubview(self.cropButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gridButton.frame = CGRect(x: self.overlayStyle.footerSize.width - self.overlayStyle.controlButtonsSize.width - self.overlayStyle.footerSize.width / 5,
                                          y: self.overlayStyle.footerSize.height/2 - self.overlayStyle.controlButtonsSize.height/2,
                                          width: self.overlayStyle.controlButtonsSize.width,
                                          height: self.overlayStyle.controlButtonsSize.height)
        
        self.cropButton.frame = CGRect(x: self.overlayStyle.footerSize.width/2 - self.overlayStyle.captureButtonsSize.width/2,
                                          y: self.overlayStyle.footerSize.height/2 - self.overlayStyle.captureButtonsSize.height/2,
                                          width: self.overlayStyle.captureButtonsSize.width,
                                          height: self.overlayStyle.captureButtonsSize.height)
        
        self.bottomView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.overlayStyle.footerSize.width,
                                       height: self.overlayStyle.footerSize.height)
        
        self.cropButton.layer.cornerRadius = self.overlayStyle.captureButtonsSize.width/2
    }
    
    override func buttonPressed(sender: UIButton) {
        super.buttonPressed(sender: sender)
        
        if sender == self.gridButton {
            self.footerDelegate?.gridButtonPressed()
        } else {
            self.footerDelegate?.cropButtonPressed()
        }
    }
}
