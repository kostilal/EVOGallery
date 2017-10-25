//
//  DemoGalleryCollectionViewController.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 23.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

class DemoGalleryCollectionViewController: EVOGalleryViewController, HeaderViewDelegate, FooterViewDelegate, EVOGalleryViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        addView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Setups
    
    func addView() {
        let header = HeaderView()
        header.viewDelegate = self
        self.headerView = header
        
        let footer = FooterView()
        footer.viewDelegate = self
        self.footerView = footer
        
        setupOverlays()
    }
    
    // MARK: HeaderViewDelegate
    func headerViewDidPressBackButton(_ headerView: HeaderView?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func headerViewDidPressShareButton(_ headerView: HeaderView?) {
        let image = self.dataSource[self.currentIndex]
        
        share(shareText: "YOBA", shareImage: image)
    }
    
    // MARK: FooterViewDelegate
    func footerView(_ footerView: FooterView, didPressEditButton button: UIButton) {
        let cameraVC = EVOCameraViewController()
        
        present(cameraVC, animated: true, completion: nil)
    }
    
    func footerView(_ footerView: FooterView, didPressDeleteButton button: UIButton) {
        if self.currentIndex <= self.dataSource.count-1 {
            self.dataSource.remove(at: self.currentIndex)
        }
        
        if self.dataSource.isEmpty {
            headerViewDidPressBackButton(nil)
            
            return
        }
        
        self.scroll(to: 0)
        
        self.reloadData()
    }
    
    // MARK: EVOGalleryViewControllerDelegate
    func galleryDidChangeIndex(to index: Int, galleryViewController: EVOGalleryViewController) {
        guard let header = galleryViewController.headerView as? HeaderView else {
            return
        }
        
        header.titleLabel.text = "Фото \(index+1) из \(self.dataSource.count)"
    }
    
    // MARK: Actions
    func share(shareText:String?, shareImage:UIImage?){
        
        var objectsToShare = [AnyObject]()
        
        if let shareTextObj = shareText{
            objectsToShare.append(shareTextObj as AnyObject)
        }
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if shareText != nil || shareImage != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }else{
            print("There is nothing to share")
        }
    }
}
