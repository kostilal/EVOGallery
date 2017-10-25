//
//  EVOCameraFocusView.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 25.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit
import CoreGraphics

class EVOCameraFocusView: UIView {
    public var focusStrokeColor: UIColor!
    public var focusStrokeWidth: CGFloat!
    public var focusDisplayingDuration: Double!
    public var focusPoint: CGPoint!
    public var focusSize: CGSize!
    
    private var shouldDrawFocus: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupDefaults()
    }
    
    override func draw(_ rect: CGRect) {
        drawFocus()
    }
    
    // MARK: Setup
    private func setupDefaults() {
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        
        self.focusStrokeColor = .orange
        self.focusStrokeWidth = 1.0
        self.focusDisplayingDuration = 1.0
        self.focusPoint = self.center
        self.focusSize = CGSize(width: 100, height: 100)
        self.shouldDrawFocus = false
    }
    
    // MARK: Actions
    private func drawFocus() {
        if !self.shouldDrawFocus {
            return
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.saveGState()
        
        UIColor.clear.setFill()
        self.focusStrokeColor.setStroke()
        
        context.setLineWidth(self.focusStrokeWidth)
        context.stroke(CGRect(x: self.focusPoint.x - CGFloat(roundf(Float(self.focusSize.width/2))),
                              y: self.focusPoint.y - CGFloat(roundf(Float(self.focusSize.height/2))),
                              width: self.focusSize.width,
                              height: self.focusSize.height))
        
        for index in 0...3 {
            var endPoint = CGPoint()
            
            switch index {
            case 0:
                context.move(to: CGPoint(x: self.focusPoint.x,
                                         y: self.focusPoint.y - CGFloat(roundf(Float(self.focusSize.height/2)))))
                
                endPoint = CGPoint(x: self.focusPoint.x,
                                   y: self.focusPoint.y - CGFloat(roundf(Float(self.focusSize.height/2))) + 10)
                break;
            case 1:
                context.move(to: CGPoint(x: self.focusPoint.x,
                                         y: self.focusPoint.y + CGFloat(roundf(Float(self.focusSize.height/2)))))
                
                endPoint = CGPoint(x: self.focusPoint.x,
                                   y: self.focusPoint.y + CGFloat(roundf(Float(self.focusSize.height/2))) - 10)
                break;
            case 2:
                context.move(to: CGPoint(x: self.focusPoint.x - CGFloat(roundf(Float(self.focusSize.width/2))),
                                         y: self.focusPoint.y))

                endPoint = CGPoint(x: self.focusPoint.x - CGFloat(roundf(Float(self.focusSize.width/2))) + 10,
                                   y: self.focusPoint.y)
                break;
            case 3:
                context.move(to: CGPoint(x: self.focusPoint.x + CGFloat(roundf(Float(self.focusSize.width/2))),
                                         y: self.focusPoint.y))

                endPoint = CGPoint(x: self.focusPoint.x + CGFloat(roundf(Float(self.focusSize.width/2))) - 10,
                                   y: self.focusPoint.y)
                break;
            default:
                break;
            }
            
            context.addLine(to: endPoint)
        }
        
        context.drawPath(using: CGPathDrawingMode.fillStroke)
        context.restoreGState()
    }
    
    public func setFocus(point: CGPoint) {
        self.focusPoint = point
        
        DispatchQueue.main.async { [weak self] in
            self?.shouldDrawFocus = true
            self?.setNeedsDisplay()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.focusDisplayingDuration) { [weak self] in
            self?.shouldDrawFocus = false
            self?.setNeedsDisplay()
        }
    }
}
