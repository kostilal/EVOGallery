//
//  DemoGalleryCollectionViewController.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 23.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

class DemoGalleryCollectionViewController: EVOGalleryViewController, EVOGalleryViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.galeryDelegate = self

//        addView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Setups
    
//    func addView() {
//        let header = EVOGalleryHeaderView()
//        header.headerDelegate = self
//        self.headerView = header
//
//        let footer = EVOGalleryFooterView()
//        footer.footerDelegate = self
//        self.footerView = footer
//
//        setupOverlays()
//    }
//
//    // MARK: HeaderViewDelegate
//    func headerViewDidPressBackButton(_ headerView: EVOGalleryHeaderView?) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func headerViewDidPressShareButton(_ headerView: EVOGalleryHeaderView?) {
////        let image = self.dataSource[self.currentIndex]
////
////        share(shareText: "YOBA", shareImage: image)
//    }
    
    // MARK: FooterViewDelegate
//    func footerView(_ footerView: EVOGalleryFooterView, didPressEditButton button: UIButton) {
//
//    }
//
//    func footerView(_ footerView: EVOGalleryFooterView, didPressDeleteButton button: UIButton) {
//        if self.currentIndex <= self.dataSource.count-1 {
//            self.dataSource.remove(at: self.currentIndex)
//        }
//
//        if self.dataSource.isEmpty {
//            headerViewDidPressBackButton(nil)
//
//            return
//        }
//
//        self.scroll(to: 0)
//
//        self.reloadData()
//    }
    
    // MARK: EVOGalleryViewControllerDelegate
    func galleryDidChangeIndex(to index: Int, galleryViewController: EVOGalleryViewController) {
//        guard let header = galleryViewController.headerView else {
//            return
//        }
        
//        header.titleLabel.text = String(format: "gallery.title.text", index+1, self.dataSource.count)
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
