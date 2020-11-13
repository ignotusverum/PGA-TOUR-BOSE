//
//  PlayerListSetup.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/3/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import PlayersModule

typealias PlayersListRouteEvent = PlayerListModuleEvents

extension ModuleRoutingStep {
    static func playerList(routingContext: RoutingContextType = .main) -> ModuleRoutingStep {
        let context = PlayersModuleContext(routingContext: routingContext.rawValue, tournamentId: 480)
        return ModuleRoutingStep(withMaker: context)
    }
}
