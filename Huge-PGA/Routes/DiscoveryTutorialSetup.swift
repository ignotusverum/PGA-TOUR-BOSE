//
//  OnboardingTutorialSetup.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import DiscoveryTutorialModule
import MERLin

typealias DiscoveryTutorialRouteEvent = DiscoveryTutorialModuleEvents

extension ModuleRoutingStep {
    static func discoveryTutorial(routingContext: RoutingContextType = .main) -> ModuleRoutingStep {
        let context = DiscoveryTutorialModuleContext(routingContext: routingContext.rawValue)
        return ModuleRoutingStep(withMaker: context)
    }
}
