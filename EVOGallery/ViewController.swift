//
//  ViewController.swift
//  EVOGallery
//
//  Created by Костюкевич Илья on 21.10.2017.
//  Copyright © 2017 Костюкевич Илья. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, EVOCollectionViewDelegate, EVOCameraViewControllerDelegate {
    var datasource = [EVOCollectionDTO]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0...5 {
            let image = UIImage(named: "test_\(index)")
            let dto = EVOCollectionDTO()
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

        let gallery = DemoGalleryCollectionViewController(with: self.datasource, selectedIndex: index, collectionViewLayout: nil)
        present(gallery, animated: true, completion: nil)
    }
    
    func addImage() {
        let camera = EVOCameraViewController()
        camera.cameraDelegate = self
        self.navigationController?.pushViewController(camera, animated: true)
    }
    
    func deleteImage() {
        
    }
    
    func reloadImage() {
        
    }
    
    func cameraDidCapture(image: EVOCollectionDTO) {
        self.datasource.append(image)
        self.collectionView.reloadData()
    }
    
    func cameraDidCanceled() {
        
    }
}

