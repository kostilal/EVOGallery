//
//  EVOCroperRectView.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 02.11.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

class EVOCroperRectView: UIView {
    public var gridIsHidden: Bool = false {
        didSet {
            self.gridLayer.isHidden = self.gridIsHidden
        }
    }
    
    public var lineWidth: CGFloat = 1.0
    private var gridLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        drawRect()
        drawGrid()
    }

    func drawRect() {
        let rect = CALayer()
        rect.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.layer.addSublayer(rect)
        
        let line0 = CALayer()
        line0.frame = CGRect(x: 0, y: 0, width: self.bounds.width - self.lineWidth, height: self.lineWidth)
        line0.backgroundColor = UIColor.white.cgColor
        rect.addSublayer(line0)
        
        let line1 = CALayer()
        line1.frame = CGRect(x: self.bounds.width - self.lineWidth, y: 0, width: self.lineWidth, height: self.bounds.height)
        line1.backgroundColor = UIColor.white.cgColor
        rect.addSublayer(line1)
        
        let line2 = CALayer()
        line2.frame = CGRect(x: 0, y: self.bounds.height - self.lineWidth , width: self.bounds.width - self.lineWidth, height: self.lineWidth)
        line2.backgroundColor = UIColor.white.cgColor
        rect.addSublayer(line2)
        
        let line3 = CALayer()
        line3.frame = CGRect(x: 0, y: 0, width: self.lineWidth, height: self.bounds.height - self.lineWidth)
        line3.backgroundColor = UIColor.white.cgColor
        rect.addSublayer(line3)
    }
    
    func drawGrid() {
        self.gridLayer.isHidden = self.gridIsHidden
        
        self.gridLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.layer.addSublayer(self.gridLayer)
        
        let line0 = CALayer()
        line0.frame = CGRect(x: self.bounds.width/3, y: 0, width: self.lineWidth, height: self.bounds.height)
        line0.backgroundColor = UIColor.white.cgColor
        self.gridLayer.addSublayer(line0)
        
        let line1 = CALayer()
        line1.frame = CGRect(x: self.bounds.width - (self.bounds.width/3), y: 0, width: self.lineWidth, height: self.bounds.height)
        line1.backgroundColor = UIColor.white.cgColor
        self.gridLayer.addSublayer(line1)
        
        let line2 = CALayer()
        line2.frame = CGRect(x: 0, y: self.bounds.height/3, width: self.bounds.width, height: self.lineWidth)
        line2.backgroundColor = UIColor.white.cgColor
        self.gridLayer.addSublayer(line2)
        
        let line3 = CALayer()
        line3.frame = CGRect(x: 0, y: self.bounds.height - (self.bounds.height/3), width: self.bounds.width, height: self.lineWidth)
        line3.backgroundColor = UIColor.white.cgColor
        self.gridLayer.addSublayer(line3)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
