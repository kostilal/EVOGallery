//
//  ImageLoaderCollectionView.swift
//  ImageLoaderCollectionView
//
//  Created by Костюкевич Илья on 16.08.17.
//  Copyright © 2017 evo.company. All rights reserved.
//

import UIKit

enum AddButtonPosition: Int {
    case first
    case last
}

protocol EVOCollectionViewDelegate: class {
    func addImage()
    func deleteImage()
    func reloadImage()
    func selectItem(at index: Int)
}

class EVOCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var selectedCell: EVOCollectionViewCell?
    private var objects = [EVOCollectionDTO]()
    
    public var overlaysStyle = EVOOverlaysStyle()
    public weak var imageLoaderDelegate: EVOCollectionViewDelegate?
    public var addButtonPosition: AddButtonPosition = .first {
        didSet {
            sort(dataSource: self.objects, with: self.addButtonPosition)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        defaultSetup()
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        defaultSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(objects: [EVOCollectionDTO]) {
        sort(dataSource: objects, with: self.addButtonPosition)
    }
    
    // MARK: Setups
    func defaultSetup() {
        self.register(EVOCollectionAddAttachmentCell.self, forCellWithReuseIdentifier: "EVOCollectionAddAttachmentCell")
        self.register(EVOCollectionAttachmentCell.self, forCellWithReuseIdentifier: "EVOCollectionAttachmentCell")
        
        setupCollectionView()
        setupGestureRecognizer()
        setupDataSource()
    }
    
    func setupDataSource() {
        self.objects.append(EVOCollectionDTO())
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        self.collectionViewLayout = layout
        self.delegate = self
        self.dataSource = self
    }
    
    func setupGestureRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        self.addGestureRecognizer(longPress)
    }

    // MARK: GestureRecognizer
    
    @objc func handleLongGesture(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            guard let indexPath = self.indexPathForItem(at: recognizer.location(in: self)) else {
                return
            }
            
            guard let cell = self.cellForItem(at: indexPath) as? EVOCollectionViewCell else {
                fatalError("Can't init cell ImageLoaderCollectionViewCell")
            }
            
            self.selectedCell = cell
            
            if self.selectedCell?.cellType == .add {
                return
            }
            
            self.beginInteractiveMovementForItem(at: indexPath)
            UIView.animate(withDuration: 0.1, animations: {
                self.selectedCell?.contentView.transform = CGAffineTransform.identity.scaledBy(x: 1.02, y: 1.02)
            })
            break
        case .changed:
            guard let indexPath = self.indexPathForItem(at: recognizer.location(in: recognizer.view)) else {
                return
            }
            
            guard let cell = self.cellForItem(at: indexPath) as? EVOCollectionViewCell else {
                fatalError("Can't init cell ImageLoaderCollectionViewCell")
            }
            
            if cell.cellType != .add {
                self.updateInteractiveMovementTargetPosition(recognizer.location(in: recognizer.view))
            } else {
                self.endInteractiveMovement()
            }
            break
        case .ended:
            UIView.animate(withDuration: 0.1, animations: {
                self.selectedCell?.contentView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
            })
            
            self.endInteractiveMovement()
            break
        default:
            self.cancelInteractiveMovement()
            break
        }
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let addButtonIndex = self.addButtonPosition == .first ? 0 : self.objects.count - 1
        
        if indexPath.row == addButtonIndex {
            guard let cell = self.dequeueReusableCell(withReuseIdentifier: "EVOCollectionAddAttachmentCell", for: indexPath) as? EVOCollectionAddAttachmentCell else {
                fatalError("Can't init cell AddAttachmentCollectionViewCell")
            }
            
            cell.cellType = .add
            
            return cell
        }
        
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: "EVOCollectionAttachmentCell", for: indexPath) as? EVOCollectionAttachmentCell else {
            fatalError("Can't init cell AttachmentCollectionViewCell")
        }
        
        cell.cellType = .created
        cell.set(object: self.objects[indexPath.row], deleteCompletition: {[weak self] (result) in
            guard let object = result else {
                return
            }
            
            self?.deleteImage(object)
        }) {[weak self] (result) in
            guard let object = result else {
                return
            }
            
            self?.reloadImage(object)
        }
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EVOCollectionViewCell else {
            fatalError("Can't init cell AttachmentCollectionViewCell")
        }
        
        if cell.cellType == .add {
            addImage()
        } else {
            var images = self.objects
            
            if addButtonPosition == .first {
                images.removeFirst()
            } else {
                images.removeLast()
            }
            
            imageLoaderDelegate?.selectItem(at: indexPath.row - 1)
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.height - self.overlaysStyle.collectionCellHeightMargin,
                      height: self.bounds.height - self.overlaysStyle.collectionCellHeightMargin)
    }
    
    // MARK: Actions
    func sort(dataSource: [EVOCollectionDTO], with addButtonPosition: AddButtonPosition) {
        self.objects.removeAll()
        self.objects.append(EVOCollectionDTO()) // Append ADD button
        
        dataSource.forEach { (object) in
            switch addButtonPosition {
            case .first:
                self.objects.append(object)
                break
            case .last:
                self.objects.insert(object, at: 0)
                break
            }
        }
        
        self.reloadData()
    }
    
    func addImage() {
        imageLoaderDelegate?.addImage()
    }

    func deleteImage(_ object: EVOCollectionDTO) {
        guard let index = self.objects.index(of: object) else {
            return
        }
        
        self.objects.remove(at: index)
        self.reloadData()
    }
    
    func reloadImage(_ object: EVOCollectionDTO) {
        let findObject = self.objects.first{ $0 == object}
        
        guard let obj = findObject else {
            return
        }
        
        obj.status = .loading
        
        self.reloadData()
    }
}
