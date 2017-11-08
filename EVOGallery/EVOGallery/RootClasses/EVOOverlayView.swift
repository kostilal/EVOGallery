//
//  OverlayView.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 07.11.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

protocol EVOOverlayViewDelegate: class {
    func closeButtonPressed()
}

class EVOOverlayView: UIView {
    public var overlayStyle: EVOOverlaysStyle!
    public weak var overlayDelegate: EVOOverlayViewDelegate?
    
    init(with style: EVOOverlaysStyle!) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: style.headerSize.height))
        
        self.overlayStyle = style
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.overlayStyle = EVOOverlaysStyle()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.overlayStyle = EVOOverlaysStyle()
        setupUI()
    }
    
    public func setupUI() {
        
    }
    
    @objc public func buttonPressed(sender: UIButton) {
        UIView.animate(withDuration: 0.05,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            sender.transform = CGAffineTransform.identity
                        }
        })
    }
}
