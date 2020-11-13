//
//  HomeModel.swift
//  HomeModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

struct HomeModel {
    var items: [HomeItem] = [
        HomeItem(title: "Find a Player",
                 image: Asset.iconUser.image,
                 type: .players),
        HomeItem(title: "Points of Interest",
                 image: Asset.iconPlace.image,
                 type: .pointsOfInterest)
    ]
}
