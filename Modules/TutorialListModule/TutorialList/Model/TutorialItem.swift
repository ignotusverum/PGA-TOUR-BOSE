//
//  TutorialCard.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/15/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation
import UIKit

enum TutorialItemType {
    case navigation
    case discovery
}

struct TutorialItem: Equatable {
    var title: String
    var iconImage: UIImage
    var description: String
    var type: TutorialItemType
}
