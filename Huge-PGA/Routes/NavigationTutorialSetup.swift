//
//  NavigationTutorialSetup.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import NavigationTutorialModule

typealias NavigationTutorialRouteEvent = NavigationTutorialModuleEvents

extension ModuleRoutingStep {
    static func navigationTutorial(routingContext: RoutingContextType = .main) -> ModuleRoutingStep {
        let context = NavigationTutorialModuleContext(routingContext: routingContext.rawValue)
        return ModuleRoutingStep(withMaker: context)
    }
}
