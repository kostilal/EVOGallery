//
//  EVOCropperHeaderView.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 06.11.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

class EVOCroperHeaderView: EVOOverlayView {
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.closeButtonImage, for: .normal)
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backButton.frame = CGRect(x: 0,
                                       y: self.overlayStyle.headerSize.height - self.overlayStyle.buttonMargin - self.overlayStyle.controlButtonsSize.height,
                                       width: self.overlayStyle.controlButtonsSize.width,
                                       height: self.overlayStyle.controlButtonsSize.height)
        
        self.navigationView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.overlayStyle.headerSize.width,
                                           height: self.overlayStyle.headerSize.height)
    }
    
    override func buttonPressed(sender: UIButton) {
        super.buttonPressed(sender: sender)
        
        self.overlayDelegate?.closeButtonPressed()
    }
}
