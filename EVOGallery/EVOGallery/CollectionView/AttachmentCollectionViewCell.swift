//
//  ImageLoaderCollectionViewCell.swift
//  ImageLoaderCollectionView
//
//  Created by Костюкевич Илья on 16.08.17.
//  Copyright © 2017 evo.company. All rights reserved.
//

import UIKit

class AttachmentCollectionViewCell: ImageLoaderCollectionViewCell {
    fileprivate static let kImageViewTopMargin = CGFloat(8)
    fileprivate static let kDeleteButtonSize = CGSize(width: 30, height: 30)
    fileprivate static let kReloadButtonSize = CGSize(width: 30, height: 30)

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"clean")!, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .gray
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var reloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"refresh")!, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .gray
        button.addTarget(self, action: #selector(reloadButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.color = UIColor(red: 81/255, green: 73/255, blue: 157/255, alpha: 1)
        
        return indicatorView
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
        
        self.imageView.frame = CGRect(x: 0,
                                 y: AttachmentCollectionViewCell.kImageViewTopMargin,
                                 width: self.contentView.frame.size.width - AttachmentCollectionViewCell.kImageViewTopMargin,
                                 height: self.contentView.frame.size.width - AttachmentCollectionViewCell.kImageViewTopMargin)
        
        self.deleteButton.frame = CGRect(x: self.contentView.frame.size.width - AttachmentCollectionViewCell.kDeleteButtonSize.width,
                                    y: 0,
                                    width: AttachmentCollectionViewCell.kDeleteButtonSize.width,
                                    height: AttachmentCollectionViewCell.kDeleteButtonSize.height)
        
        self.reloadButton.frame = CGRect(x: self.contentView.frame.size.width/2 - AttachmentCollectionViewCell.kReloadButtonSize.width/2 - AttachmentCollectionViewCell.kImageViewTopMargin/2,
                                    y: self.contentView.frame.size.height/2 - AttachmentCollectionViewCell.kReloadButtonSize.height/2 + AttachmentCollectionViewCell.kImageViewTopMargin/2,
                                    width: AttachmentCollectionViewCell.kReloadButtonSize.width,
                                    height: AttachmentCollectionViewCell.kReloadButtonSize.height)
        
        self.activityIndicator.frame = CGRect(x: contentView.frame.size.width/2 - self.activityIndicator.frame.width/2 - AttachmentCollectionViewCell.kImageViewTopMargin/2,
                                    y: self.contentView.frame.size.height/2 - self.activityIndicator.frame.height/2 + AttachmentCollectionViewCell.kImageViewTopMargin/2,
                                    width: self.activityIndicator.frame.width,
                                    height: self.activityIndicator.frame.height)
        
        self.reloadButton.layer.cornerRadius = reloadButton.frame.size.height/2
        self.deleteButton.layer.cornerRadius = deleteButton.frame.size.height/2
    }
    
    // MARK: Setups
    
    func setupUI() {
        self.addSubview(self.imageView)
        self.addSubview(self.deleteButton)
        self.addSubview(self.reloadButton)
        self.addSubview(self.activityIndicator)
    }
    
    func set(object: ImageLoaderDTO, deleteCompletition: @escaping DeleteBlock, reloadCompletition: @escaping ReloadBlock) {
        self.object = object
        self.deleteCompletition = deleteCompletition
        self.reloadCompletition = reloadCompletition
        
        statusChanged(to: object.status)
        
        if let image = self.object?.image {
            self.imageView.image = image
        }
    }
    
    // MARK: Actions
    
    @objc func deleteButtonPressed() {
        guard let block = self.deleteCompletition else {
            return
        }
        
        block(self.object)
    }
    
    @objc func reloadButtonPressed() {
        guard let block = self.reloadCompletition else {
            return
        }
        
        block(self.object)
    }
    
    func statusChanged(to status: LoadingStatus) {
        switch status {
        case .none, .upload:
            blur(visible: false)
            self.reloadButton.isHidden = true
            self.activityIndicator.isHidden = true
            break
        case .loading:
            blur(visible: true)
            self.reloadButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            break
        case .error:
            blur(visible: false)
            self.reloadButton.isHidden = false
            self.activityIndicator.isHidden = true
            break
        }
    }
    
    // MARK: Effects
    
    func blur(visible: Bool) {
        if visible {
            let blurEffectView = UIVisualEffectView.init(frame: self.imageView.bounds)
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            UIView.animate(withDuration: 0.1, animations: {
                blurEffectView.effect = UIBlurEffect.init(style: .light)
            })
            
            self.imageView.addSubview(blurEffectView)
        } else {
            guard let blurEffectView = self.imageView.subviews.first else {
                return
            }
            
            blurEffectView.removeFromSuperview()
        }
    }
}
