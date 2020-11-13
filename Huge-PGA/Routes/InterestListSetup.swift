//
//  InterestListSetup.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/8/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import InterestsModule
import MERLin

typealias InterestListRouteEvent = InterestsModuleEvents

extension ModuleRoutingStep {
    static func interestList(routingContext: RoutingContextType = .main) -> ModuleRoutingStep {
        let context = InterestsModuleContext(routingContext: routingContext.rawValue, fileName: "quail_hollow_club.json")
        return ModuleRoutingStep(withMaker: context)
    }
}
