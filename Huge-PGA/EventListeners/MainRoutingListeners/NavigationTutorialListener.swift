//
//  NavigationTutorialListener.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

class NavigationTutorialListener: ModuleEventsListener {
    var router: Router
    init(_ router: Router) {
        self.router = router
    }
    
    func listenEvents(from module: AnyEventsProducerModule,
                      events: Observable<NavigationTutorialRouteEvent>) -> Bool {
        return true
    }
}
