//
//  PlayerListListener.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/4/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

import CoreLocation

class PlayerListListener: ModuleEventsListener {
    var router: Router
    init(_ router: Router) {
        self.router = router
    }
    
    func listenEvents(from module: AnyEventsProducerModule,
                      events: Observable<PlayersListRouteEvent>) -> Bool {
        let playerObservable = events
            .capture(case: PlayersListRouteEvent.playerSelected)
            .toRoutableObservable()
        
        let iterestObservable = InterestAdapter.fetch(jsonFile: "quail_hollow_club.json")
        
        Observable.zip(playerObservable, iterestObservable)
            .map { (playerInfo, interest) in (interest.first(where: { $0.id == playerInfo.0 }), playerInfo.1) }
            .subscribe(onNext: { [weak module] (playerHole, location) in
                guard let playerHole = playerHole,
                    let module = module,
                    let rootViewController = module.rootViewController,
                    let originLocation = LocationManager.lastLocation else { return }
                
                let destName = "\(playerHole.info?.formattedHoleNumber ?? "") \(location)"
                var destCoordinates: CLLocationCoordinate2D
                switch location {
                case "tee": destCoordinates = CLLocationCoordinate2D(latitude: playerHole.startCoords.lat,
                                                                     longitude: playerHole.startCoords.lng)
                default: destCoordinates = CLLocationCoordinate2D(latitude: playerHole.endCoords.lat,
                                                                  longitude: playerHole.endCoords.lng)
                }
                
                let origin = HWaypoint(coordinate: CLLocationCoordinate2D(latitude: originLocation.coordinate.latitude,
                                                                          longitude: originLocation.coordinate.longitude), title: "")
                let destination = HWaypoint(coordinate: destCoordinates, title: destName)
                
                rootViewController.showLoading()
                
                DirectionsManager.shared
                    .showDirections(origin: origin,
                                    paths: [destination],
                                    in: rootViewController)
            })
            .disposed(by: module.disposeBag)
        
        return true
    }
}
