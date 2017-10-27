//
//  EVOCameraOverlaysStyle.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 26.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

final class EVOCameraOverlaysStyle: NSObject {
    public var closeButtonImage: UIImage!
    public var switchButtonImage: UIImage!
    public var flashButtonImages: [String: UIImage]!
    public var galleryButtonImage: UIImage!
    public var captureButtonImage: UIImage!
    public var applyButtonImage: UIImage!
    public var rotateButtonImage: UIImage!
    public var cropButtonImage: UIImage!
    
    public var controlButtonsTintColor: UIColor!
    public var captureButtonTintColor: UIColor!
    public var cropButtonTintColor: UIColor!
    public var focusRectColor: UIColor!
    public var headerBackgroundColor: UIColor!
    public var footerBackgroundColor: UIColor!
    
    public var controlButtonsSize: CGSize!
    public var captureButtonsSize: CGSize!
    public var headerSize: CGSize!
    public var footerSize: CGSize!
    
    override init() {
        super.init()
        
        defaultSetups()
    }
    
    fileprivate func defaultSetups() {
        self.closeButtonImage = createImage(named: "back")
        self.switchButtonImage = createImage(named: "switch")
        self.galleryButtonImage = createImage(named: "gallery")
        self.captureButtonImage = createImage(named: "photo")
        self.applyButtonImage = createImage(named: "apply")
        self.rotateButtonImage = createImage(named: "rotate")
        self.cropButtonImage = createImage(named: "crop")
        self.flashButtonImages = [FlashState.auto.rawValue: createImage(named: "flash_auto"),
                                  FlashState.on.rawValue  : createImage(named: "flash_on"),
                                  FlashState.off.rawValue : createImage(named: "flash_off")]
        
        self.controlButtonsTintColor = .white
        self.captureButtonTintColor = UIColor(red: 81/255, green: 73/255, blue: 157/255, alpha: 1)
        self.cropButtonTintColor = UIColor(red: 81/255, green: 73/255, blue: 157/255, alpha: 1)
        self.focusRectColor = UIColor(red: 81/255, green: 73/255, blue: 157/255, alpha: 1)
        self.headerBackgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        self.footerBackgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        
        self.controlButtonsSize = CGSize(width: 30, height: 30)
        self.captureButtonsSize = CGSize(width: 56, height: 56)
        self.headerSize = CGSize(width: UIScreen.main.bounds.size.width, height: 64)
        self.footerSize = CGSize(width: UIScreen.main.bounds.size.width, height: 79)
    }
    
    fileprivate func createImage(named: String) -> UIImage! {
        guard let image = UIImage(named: named) else {
            return UIImage()
        }
        
        return image
    }
}
