//
//  EVOCroperViewController.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 02.11.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

protocol EVOCroperViewControllerDelegate: class {
    func croperDidCrop(image: EVOCollectionDTO)
    func croperDidCanceled()
}

class EVOCroperViewController: UIViewController, EVOOverlayViewDelegate, EVOCroperFooterDelegate {

    public var sourceImage: EVOCollectionDTO?
    public var headerView: EVOCroperHeaderView?
    public var footerView: EVOCroperFooterView?
    public var overlaysStyle = EVOOverlaysStyle()
    public weak var croperDelegate: EVOCroperViewControllerDelegate?
    
    private var cropView = EVOCroperRectView()
    private var scrollView = EVOGalleryImageScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupOverlays()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.overlaysStyle.statusBarStyle
    }
    
    // MARK: Setups
    func setupUI() {
        guard let image = self.sourceImage?.image else {
            log(with: "No image provided")
            return
        }
        
        
        self.scrollView.frame = self.view.frame
        self.scrollView.display(image: image)
        self.view.addSubview(self.scrollView)
        
        self.cropView.frame = CGRect(x: 0,
                                     y: 64,
                                     width: self.view.frame.size.width,
                                     height: self.view.frame.size.height - self.overlaysStyle.headerSize.height - self.overlaysStyle.footerSize.height)
        self.cropView.lineWidth = self.overlaysStyle.croperLineWidth
        self.cropView.gridIsHidden = self.overlaysStyle.isCroperGridHidden
        self.view.addSubview(self.cropView)
    }
    
    func setupOverlays() {
        self.headerView = EVOCroperHeaderView(with: self.overlaysStyle)
        self.headerView?.overlayDelegate = self
        self.view.addSubview(self.headerView!)
        
        self.footerView = EVOCroperFooterView(with: self.overlaysStyle)
        self.footerView?.footerDelegate = self
        self.view.addSubview(self.footerView!)
    }
    
    // MARK: Actions
    func cropImage() {
        guard let image = self.sourceImage?.image else {
            return
        }
        
        let newSize = CGSize(width: image.size.width * self.scrollView.zoomScale, height: image.size.height * self.scrollView.zoomScale)
        let offset = self.scrollView.contentOffset
        
        UIGraphicsBeginImageContextWithOptions(self.cropView.frame.size, false, 0)
        var sharpRect = CGRect(x: -offset.x, y: -offset.y, width: newSize.width, height: newSize.height)
        sharpRect = sharpRect.integral
        
        image.draw(in: sharpRect)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let imageData = UIImagePNGRepresentation(finalImage!) {
            if let image = UIImage(data: imageData) {
                didCrop(image: image)
            } else {
                log(with: "No image from image data")
                didCanceled()
            }
        } else {
            log(with: "No image data")
            didCanceled()
        }
    }
    
    func didCrop(image: UIImage) {
        guard let imageDTO = self.sourceImage else {
            return
        }
        
        imageDTO.image = image
        self.croperDelegate?.croperDidCrop(image: imageDTO)
        
        close(animated: false)
    }
    
    func didCanceled() {
        self.croperDelegate?.croperDidCanceled()
        
        close(animated: false)
    }
    
    func showGrid() {
        self.cropView.gridIsHidden = !self.cropView.gridIsHidden
    }
    
    func close(animated: Bool) {
        if let _ = self.navigationController {
            self.navigationController?.popViewController(animated: animated)
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }
    
    fileprivate func log(with text: String) {
        print(text)
    }
    
    // MARK: EVOCroperHeaderDelegate
    func closeButtonPressed() {
        close(animated: true)
    }
    
    // MARK: EVOCroperFooterDelegate
    func gridButtonPressed() {
        showGrid()
    }
    
    func cropButtonPressed() {
        cropImage()
    }
}
