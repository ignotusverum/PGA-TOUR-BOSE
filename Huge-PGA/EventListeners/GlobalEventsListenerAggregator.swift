//
//  GlobalEventsListenerAggregator.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/13/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

class GlobalEventsListenerAggregator: EventsListenersAggregator {
    let listeners: [AnyEventsListener] = [
        WearableEventsListener(),
        WearableSessionEventsListener(),
        LocationManagerEventsListener()
    ]
    
    func listenEvents() {
        listeners.forEach { listener in
            switch listener {
            case let listener as WearableEventsListener: listener.listenEvents(from: WearableManager.shared)
            case let listener as LocationManagerEventsListener: listener.listenEvents(from: LocationManager.shared)
            case let listener as WearableSessionEventsListener: listener.listenEvents(from: WearableSessionManager.shared)
            default: return
            }
        }
    }
}
