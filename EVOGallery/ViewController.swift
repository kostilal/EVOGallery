//
//  ViewController.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 21.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ImageLoaderCollectionViewDelegate {
    var datasource = [ImageLoaderDTO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0...5 {
            let image = UIImage(named: "test_\(index)")
            let dto = ImageLoaderDTO()
            dto.image = image
            
            self.datasource.append(dto)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionViewCell", for: indexPath) as! TestCollectionViewCell
        
        cell.collectionView.set(objects: self.datasource)
        cell.collectionView.imageLoaderDelegate = self
        
        return cell
    }
    
    func selectItem(at index: Int) {
        var images = [UIImage]()
        
        self.datasource.forEach { (dto) in
            images.append(dto.image!)
        }
        
        let gallery = DemoGalleryCollectionViewController(with: images, selectedIndex: index, collectionViewLayout: nil)
        present(gallery, animated: true, completion: nil)
    }
    
    func addImage() {
        let camera = EVOCameraViewController()
        self.navigationController?.pushViewController(camera, animated: true)
//        present(camera, animated: true, completion: nil)
        
    }
    
    func deleteImage() {
        
    }
    
    func reloadImage() {
        
    }
}

