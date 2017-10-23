//
//  EVOGalleryCollectionViewCell.swift
//  Gallery
//
//  Created by Костюкевич Илья on 23.10.2017.
//  Copyright © 2017 evo.company. All rights reserved.
//

import UIKit

class EVOGalleryCollectionViewCell: UICollectionViewCell {
    fileprivate var scrollView: EVOGalleryImageScrollView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupScrollView()
    }
    
    fileprivate func setupScrollView() {
        self.scrollView = EVOGalleryImageScrollView(frame: self.contentView.frame)
        
        guard let scrollView = self.scrollView else {
            return
        }
        
        self.contentView.addSubview(scrollView)
    }
    
    public func set(image: UIImage) {
        self.scrollView?.display(image: image)
    }
}
