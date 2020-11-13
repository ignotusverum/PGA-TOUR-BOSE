//
//  HomeItem.swift
//  HomeModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation
import UIKit

enum HomeItemType: Equatable {
    case players
    case pointsOfInterest
}

struct HomeItem: Equatable {
    var title: String
    var image: UIImage
    var type: HomeItemType
    
    init(title: String,
         image: UIImage,
         type: HomeItemType) {
        self.title = title
        self.type = type
        self.image = image
    }
}
