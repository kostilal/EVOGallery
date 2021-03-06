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

typealias DeleteBlock = (_ contexts: EVOCollectionDTO?) -> Void
typealias ReloadBlock = (_ contexts: EVOCollectionDTO?) -> Void

class EVOCollectionViewCell: UICollectionViewCell {
    public var cellType: CellType = .none
    public var object: EVOCollectionDTO?
    public var deleteCompletition: DeleteBlock?
    public var reloadCompletition: ReloadBlock?
}
