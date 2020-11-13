//
//  TutorialListModel.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/15/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

struct TutorialListModel {
    var items: [TutorialItem] {
        [
            TutorialItem(title: "Find a Player.",
                         iconImage: Asset.iconNavigation.image,
                         description: "Navigate the venue to find a player of your choice on the course.",
                         type: .navigation),
            TutorialItem(title: "Course Discovery.",
                         iconImage: Asset.iconDiscovery.image,
                         description: "Find out more information about points of interest on the course.",
                         type: .discovery)
        ]
    }
}
