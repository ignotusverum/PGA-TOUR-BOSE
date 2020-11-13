//
//  InterestListListener.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/8/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

import CoreLocation

class InterestListListener: ModuleEventsListener {
    var router: Router
    init(_ router: Router) {
        self.router = router
    }
    
    func listenEvents(from module: AnyEventsProducerModule,
                      events: Observable<InterestListRouteEvent>) -> Bool {
        events.capture(case: InterestListRouteEvent.interestSelected)
            .toRoutableObservable()
            .subscribe(onNext: { [weak module] interest in
                guard let module = module,
                    let rootViewController = module.rootViewController,
                    let originLocation = LocationManager.lastLocation else { return }
                
                let origin = HWaypoint(coordinate: CLLocationCoordinate2D(latitude: originLocation.coordinate.latitude,
                                                                          longitude: originLocation.coordinate.longitude), title: "")
                let endCoordinates = HWaypoint(coordinate: CLLocationCoordinate2D(latitude: interest.0, longitude: interest.1), title: interest.2)
                
                rootViewController.showLoading()
                
                DirectionsManager.shared
                    .showDirections(origin: origin,
                                    paths: [endCoordinates],
                                    in: rootViewController)
            })
            .disposed(by: module.disposeBag)
        
        return true
    }
}
