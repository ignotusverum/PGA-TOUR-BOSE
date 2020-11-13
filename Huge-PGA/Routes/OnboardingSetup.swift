//
//  OnboardingSetup.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import OnboardingModule
import MERLin

typealias OnboardingRouteEvent = OnboardingModuleEvents

extension ModuleRoutingStep {
    static func onboarding(routingContext: RoutingContextType = .main,
                           switchPageEvent: Observable<Void>)-> ModuleRoutingStep {
        let context = OnboardingModuleContext(routingContext: routingContext.rawValue,
                                              switchPageEvent: switchPageEvent)
        return ModuleRoutingStep(withMaker: context)
    }
}
