//
//  DiscoveryTutorialPage.swift
//  DiscoveryTutorialModule
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation

struct DiscoveryTutorialPage: Equatable {
    var title: String
    var type: DiscoveryTutorialType
    
    init(title: String,
         type: DiscoveryTutorialType) {
        self.type = type
        self.title = title
    }
}
