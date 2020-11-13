//
//  PlayerListActions.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/3/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum PlayerListUIAction: EventProtocol {
    case reload
    case playerSelected(Int, String)
}

enum PlayerListModelAction: EventProtocol {
    case loaded(_ tournament: Tournament)
    case error(_ error: Error)
}

enum PlayerListActions: EventProtocol {
    case ui(PlayerListUIAction)
    case model(PlayerListModelAction)
}
