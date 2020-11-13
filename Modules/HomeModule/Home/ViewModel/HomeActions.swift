//
//  HomeActions.swift
//  HomeModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum HomeUIAction: EventProtocol {
    case findPlayerTapped
    case pointsOfInterestsTapped
}

enum HomeModelAction: EventProtocol {}

enum HomeActions: EventProtocol {
    case ui(HomeUIAction)
    case model(HomeModelAction)
}
