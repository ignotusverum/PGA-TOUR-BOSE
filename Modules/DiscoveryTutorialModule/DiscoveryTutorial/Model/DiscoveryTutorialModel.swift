//
//  DiscoveryTutorialModel.swift
//  DiscoveryTutorialModule
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

struct DiscoveryTutorialModel {
    var pages: [DiscoveryTutorialPage] {
        [
            DiscoveryTutorialPage(title: "While looking at a hole on the course, tap the frames to hear information about that hole.",
                                  type: .presentation),
            DiscoveryTutorialPage(title: "In your settings, you can choose what kinds of information you’ll receive.",
                                  type: .settings)
        ]
    }
}
