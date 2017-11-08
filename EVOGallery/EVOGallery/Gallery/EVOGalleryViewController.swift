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

class EVOGalleryViewController: UICollectionViewController, EVOGalleryHeaderDelegate, EVOGalleryFooterDelegate, EVOCroperViewControllerDelegate {

    public var overlaysStyle = EVOOverlaysStyle()
    public var headerView: EVOGalleryHeaderView?
    public var footerView: EVOGalleryFooterView?
    public var dataSource = [EVOCollectionDTO]()
    public weak var galeryDelegate: EVOGalleryViewControllerDelegate?
    public var currentIndex = 0
    
    required init(with dataSource: [EVOCollectionDTO], selectedIndex: Int, collectionViewLayout: UICollectionViewFlowLayout?) {
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
        self.collectionView!.register(EVOGalleryCollectionViewCell.self, forCellWithReuseIdentifier: "EVOGalleryCollectionViewCell")
        self.collectionView?.isPagingEnabled = true
        
        setupOverlays()
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let header = self.headerView {
            header.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.overlaysStyle.headerSize.width,
                                  height: self.overlaysStyle.headerSize.height)
        }
        
        if let footer = self.footerView {
            footer.frame = CGRect(x: 0,
                                  y: self.view.frame.size.height - self.overlaysStyle.footerSize.height,
                                  width: self.overlaysStyle.footerSize.width,
                                  height: self.overlaysStyle.footerSize.height)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scroll(to: self.currentIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.overlaysStyle.statusBarStyle
    }
    
    // MARK: Setups
    public func setupOverlays() {
        self.overlaysStyle.footerSize = CGSize(width: self.overlaysStyle.footerSize.width, height: 50)
        self.overlaysStyle.footerBackgroundColor = self.overlaysStyle.focusRectColor
        
        self.headerView = EVOGalleryHeaderView(with: self.overlaysStyle)
        self.headerView?.headerDelegate = self
        self.view.addSubview(self.headerView!)
        
        self.footerView = EVOGalleryFooterView(with: self.overlaysStyle)
        self.footerView?.footerDelegate = self
        self.view.addSubview(self.footerView!)
    }
    
    // MARK: Actions
    public func scroll(to index: Int) {
        if index >= 0 && index <= self.dataSource.count-1 {
            self.collectionView?.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    public func reloadData() {
        self.collectionView?.reloadData()
        galleryDidChangeIndex()
    }
    
    private func calculateCurrentIndex(with scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView!.contentOffset
        visibleRect.size = collectionView!.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView!.indexPathForItem(at: visiblePoint)!
        
        self.currentIndex = visibleIndexPath.row
        
        galleryDidChangeIndex()
    }
    
    private func close(animated: Bool) {
        if let _ = self.navigationController {
            self.navigationController?.popViewController(animated: animated)
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }
    
    private func galleryDidChangeIndex() {
        if let header = self.headerView {
            header.titleLabel.text = String(format: NSLocalizedString("gallery.title.text", comment: ""), self.currentIndex+1, self.dataSource.count)
        }
        
        self.galeryDelegate?.galleryDidChangeIndex(to: self.currentIndex, galleryViewController: self)
    }
    
    private func openCropController() {
        let cropController = EVOCroperViewController()
        cropController.sourceImage = self.dataSource[self.currentIndex]
        cropController.croperDelegate = self
        
        if let navController = self.navigationController {
            navController.pushViewController(cropController, animated: false)
        } else {
            present(cropController, animated: false, completion: nil)
        }
    }
    
    private func shareImage(image: EVOCollectionDTO) {
        if let image = image.image {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        } else {
            log(with: "Nothing to share")
        }
    }
    
    private func log(with text: String) {
        print(text)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EVOGalleryCollectionViewCell", for: indexPath) as? EVOGalleryCollectionViewCell else {
            fatalError("Can't init EVOGalleryCollectionViewCell")
        }
    
        cell.set(image: self.dataSource[indexPath.row])
        
        return cell
    }

    // MARK: UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        calculateCurrentIndex(with: scrollView)
    }

    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        calculateCurrentIndex(with: scrollView)
    }
    
    // MARK: EVOGalleryHeaderView
    func closeButtonPressed() {
        close(animated: true)
    }
    
    func shareButtonPressed() {
        shareImage(image: self.dataSource[self.currentIndex])
    }

    // MARK: EVOGalleryFooterView
    func editButtonPressed() {
        openCropController()
    }
    
    func deleteButtonPressed() {
        
    }
    
    //MARK: EVOCroperViewControllerDelegate
    func croperDidCrop(image: EVOCollectionDTO) {
        self.dataSource[self.currentIndex] = image
        
        self.reloadData()
    }
    
    func croperDidCanceled() {
        
    }
}
