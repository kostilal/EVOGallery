//
//  AddAttachmentCollectionViewCell.swift
//  PromCabinet
//
//  Created by Костюкевич Илья on 17.08.17.
//  Copyright © 2017 Evo.company. All rights reserved.
//

import UIKit

class AddAttachmentCollectionViewCell: ImageLoaderCollectionViewCell {
    fileprivate static let kImageViewSize = CGSize(width: 24, height: 24)
    fileprivate static let kBorderViewTopMargin = CGFloat(8)
    
    lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 81/255, green: 73/255, blue: 157/255, alpha:1).cgColor
        
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photo")!
        imageView.tintColor = UIColor(red: 81/255, green: 73/255, blue: 157/255, alpha:1)
        
        return imageView
    }()
    
    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.borderView.frame = CGRect(x: 0,
                                       y: AddAttachmentCollectionViewCell.kBorderViewTopMargin,
                                       width: self.contentView.frame.size.width - AddAttachmentCollectionViewCell.kBorderViewTopMargin,
                                       height: self.contentView.frame.size.height - AddAttachmentCollectionViewCell.kBorderViewTopMargin)
        
        self.imageView.frame = CGRect(x: self.contentView.frame.size.width/2 - AddAttachmentCollectionViewCell.kImageViewSize.width/2 - AddAttachmentCollectionViewCell.kBorderViewTopMargin/2,
                                       y: self.contentView.frame.size.height/2 - AddAttachmentCollectionViewCell.kImageViewSize.height/2 + AddAttachmentCollectionViewCell.kBorderViewTopMargin/2,
                                       width: AddAttachmentCollectionViewCell.kImageViewSize.width,
                                       height: AddAttachmentCollectionViewCell.kImageViewSize.height)
    }
    
    // MARK: Setups
    func setupUI() {
        self.addSubview(self.borderView)
        self.addSubview(self.imageView)
    }
}
