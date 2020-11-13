//
//  NavigationTutorialPage.swift
//  NavigationTutorialModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import UIKit

struct NavigationTutorialPage: Equatable {
    var title: String
    var type: NavigatoinTutorialType
    
    init(title: String,
         type: NavigatoinTutorialType) {
        self.type = type
        self.title = title
    }
}
