//
//  EVOCameraHeaderView.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 26.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

protocol EVOCameraHeaderProtocol: class {
    func closeButtonPressed()
    func flashButtonPressed()
    func switchCameraButtonPressed()
}

class EVOCameraHeaderView: UIView {
    public weak var headerDelegate: EVOCameraHeaderProtocol?
    public var overlayStyle: EVOCameraOverlaysStyle!
    
    private var margin = CGFloat(8.0)
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.closeButtonImage, for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        
        return button
    }()
    
    lazy var switchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.switchButtonImage, for: .normal)
        button.addTarget(self, action: #selector(switchButtonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        
        return button
    }()
    
    lazy var flashButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.flashButtonImages[CameraFlashState.auto.rawValue], for: .normal)
        button.addTarget(self, action: #selector(flashButtonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        
        return button
    }()
    
    lazy var navigationView: UIView = {
        let navView = UIView()
        navView.backgroundColor = self.overlayStyle.headerBackgroundColor
        
        return navView
    }()
    
    init(with style: EVOCameraOverlaysStyle!) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: style.headerSize.height))
        
        self.overlayStyle = style
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.overlayStyle = EVOCameraOverlaysStyle()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.overlayStyle = EVOCameraOverlaysStyle()
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(self.navigationView)
        self.navigationView.addSubview(self.backButton)
        self.navigationView.addSubview(self.switchButton)
        self.navigationView.addSubview(self.flashButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backButton.frame = CGRect(x: 0,
                                       y: self.overlayStyle.headerSize.height - self.margin - self.overlayStyle.controlButtonsSize.height,
                                       width: self.overlayStyle.controlButtonsSize.width,
                                       height: self.overlayStyle.controlButtonsSize.height)

        self.flashButton.frame = CGRect(x: self.overlayStyle.headerSize.width - self.margin - self.overlayStyle.controlButtonsSize.width,
                                        y: self.overlayStyle.headerSize.height - self.margin - self.overlayStyle.controlButtonsSize.height,
                                        width: self.overlayStyle.controlButtonsSize.width,
                                        height: self.overlayStyle.controlButtonsSize.height)
        
        self.switchButton.frame = CGRect(x: self.overlayStyle.headerSize.width - self.margin - (self.overlayStyle.controlButtonsSize.width * 2) - 16,
                                         y: self.overlayStyle.headerSize.height - self.margin - self.overlayStyle.controlButtonsSize.height,
                                         width: self.overlayStyle.controlButtonsSize.width,
                                         height: self.overlayStyle.controlButtonsSize.height)
        
        self.navigationView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.overlayStyle.headerSize.width,
                                           height: self.overlayStyle.headerSize.height)
    }
    
    public func changeFlashImage(with state: CameraFlashState) {
        self.flashButton.setImage(self.overlayStyle.flashButtonImages[state.rawValue], for: .normal)
    }
    
    @objc func backButtonPressed() {
        self.headerDelegate?.closeButtonPressed()
    }
    
    @objc func switchButtonPressed() {
        self.headerDelegate?.switchCameraButtonPressed()
    }
    
    @objc func flashButtonPressed() {
        self.headerDelegate?.flashButtonPressed()
    }
}
