//
//  MainRoutingListenerAggregator.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

enum RoutingContextType: String, CaseIterable {
    case main
    case deeplink
}

class MainRoutingListenerAggregator: ModuleEventsListenersAggregator {
    var handledRoutingContext: [String]? = RoutingContextType.allCases.map { $0.rawValue }
    
    let moduleListeners: [AnyModuleEventsListener]
    
    init(withRouter router: Router) {
        moduleListeners = [
            HomeListener(router),
            OnboardingListener(router),
            TutorialListListener(router),
            DiscoveryTutorialListener(router),
            NavigationTutorialListener(router),
            PlayerListListener(router),
            InterestListListener(router)
        ]
    }
}
