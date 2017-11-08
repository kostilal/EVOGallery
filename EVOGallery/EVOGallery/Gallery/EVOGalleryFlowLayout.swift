//
//  EVOGalleryFlowLayout.swift
//  Gallery
//
//  Created by Костюкевич Илья on 23.10.2017.
//  Copyright © 2017 evo.company. All rights reserved.
//

import UIKit

class EVOGalleryFlowLayout: UICollectionViewFlowLayout {
    init(with frame: CGRect) {
        super.init()
        
        setup(with: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup(with: UIScreen.main.bounds)
    }
    
    private func setup(with frame: CGRect) {
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.itemSize = CGSize(width: frame.size.width, height: frame.size.height)
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
}
