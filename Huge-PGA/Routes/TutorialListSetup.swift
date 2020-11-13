//
//  TutorialListSetup.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/15/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import TutorialListModule

typealias TutorialListRouteEvent = TutorialListModuleEvents

extension ModuleRoutingStep {
    static func tutorialList(routingContext: RoutingContextType = .main) -> ModuleRoutingStep {
        let context = TutorialListModuleContext(routingContext: routingContext.rawValue)
        return ModuleRoutingStep(withMaker: context)
    }
}
