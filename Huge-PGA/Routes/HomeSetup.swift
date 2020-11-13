//
//  HomeSetup.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HomeModule
import MERLin

typealias HomeRouteEvents = HomeModuleEvents

extension ModuleRoutingStep {
    static func home(routingContext: RoutingContextType = .main) -> ModuleRoutingStep {
        let context = HomeModuleContext(routingContext: routingContext.rawValue)
        return ModuleRoutingStep(withMaker: context)
    }
}
