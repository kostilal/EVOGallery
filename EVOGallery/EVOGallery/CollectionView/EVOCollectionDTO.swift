//
//  ImageLoaderDTO.swift
//  PromCabinet
//
//  Created by Костюкевич Илья on 17.08.17.
//  Copyright © 2017 Evo.company. All rights reserved.
//

import UIKit

enum LoadingStatus: Int {
    case none
    case loading
    case upload
    case error
}

class EVOCollectionDTO: NSObject {
    var status: LoadingStatus = .none
    var image: UIImage?
}
