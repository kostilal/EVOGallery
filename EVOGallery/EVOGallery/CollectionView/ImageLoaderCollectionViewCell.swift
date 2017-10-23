//
//  ImageLoaderCollectionViewCell.swift
//  PromCabinet
//
//  Created by Костюкевич Илья on 17.08.17.
//  Copyright © 2017 Evo.company. All rights reserved.
//

import UIKit

enum CellType: Int {
    case none
    case add
    case created
}

typealias DeleteBlock = (_ contexts: ImageLoaderDTO?) -> Void
typealias ReloadBlock = (_ contexts: ImageLoaderDTO?) -> Void

class ImageLoaderCollectionViewCell: UICollectionViewCell {
    public var cellType: CellType = .none
    public var object: ImageLoaderDTO?
    public var deleteCompletition: DeleteBlock?
    public var reloadCompletition: ReloadBlock?
}
