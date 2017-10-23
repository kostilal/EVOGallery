//
//  EVOGalleryViewController.swift
//  Gallery
//
//  Created by Костюкевич Илья on 23.10.2017.
//  Copyright © 2017 evo.company. All rights reserved.
//

import UIKit

protocol EVOGalleryViewControllerDelegate: class {
    func galleryDidChangeIndex(to index: Int, galleryViewController: EVOGalleryViewController)
}

private let reuseIdentifier = "EVOGalleryCollectionViewCell"

class EVOGalleryViewController: UICollectionViewController {
    fileprivate static let headerHeight = CGFloat(64)
    fileprivate static let footerHeight = CGFloat(50)
    
    public var currentIndex = 0
    public var dataSource = [UIImage]()
    public var headerView: UIView?
    public var footerView: UIView?
    public weak var delegate: EVOGalleryViewControllerDelegate?
    
    init(with dataSource: [UIImage], selectedIndex: Int, collectionViewLayout: UICollectionViewFlowLayout?) {
        var layout: UICollectionViewFlowLayout
        
        if let collectionViewLayout = collectionViewLayout {
            layout = collectionViewLayout
        } else {
            layout = EVOGalleryFlowLayout(with: UIScreen.main.bounds)
        }
        
        super.init(collectionViewLayout: layout)
        
        self.dataSource = dataSource
        self.currentIndex = selectedIndex
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(EVOGalleryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.isPagingEnabled = true
        
        setupOverlays()
        self.delegate?.galleryDidChangeIndex(to: self.currentIndex, galleryViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView?.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Setups
    func setupOverlays() {
        if let header = self.headerView {
            header.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.view.frame.size.width,
                                  height: EVOGalleryViewController.headerHeight)
            self.view.addSubview(header)
        }
        
        if let footer = self.footerView {
            footer.frame = CGRect(x: 0,
                                  y: self.view.frame.size.height - EVOGalleryViewController.footerHeight,
                                  width: self.view.frame.size.width,
                                  height: EVOGalleryViewController.footerHeight)
            self.view.addSubview(footer)
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? EVOGalleryCollectionViewCell else {
            fatalError("Can't init EVOGalleryCollectionViewCell")
        }
    
        cell.set(image: self.dataSource[indexPath.row])
        
        return cell
    }

    // MARK: UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView!.contentOffset
        visibleRect.size = collectionView!.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView!.indexPathForItem(at: visiblePoint)!
        
        self.currentIndex = visibleIndexPath.row
        self.delegate?.galleryDidChangeIndex(to: self.currentIndex, galleryViewController: self)
    }
}
