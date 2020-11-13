//
//  LocationManagerListener.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/13/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

class LocationManagerEventsListener: EventsListener {
    func listenEvents(from producer: AnyEventsProducer,
                      events: Observable<LocationManagerEvents>) -> Bool {
        producer.capture(event: LocationManagerEvents.locationStatusChanged)
            .toRoutableObservable()
            .filter { $0 == .denied || $0 == .restricted }
            .subscribe(onNext: { status in
                print("[DEBUG] - location status changed - \(status.rawValue)")
                guard let window = UIApplication.shared.windows.first else { return }
                
                let alert = UIAlertController(title: "Whoops",
                                              message: "It looks like location services disabled. Please enable them in settings.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Open Settings",
                                              style: UIAlertAction.Style.default,
                                              handler: { _ in
                                                  guard let bundleId = Bundle.main.bundleIdentifier,
                                                      let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") else { return }
                                                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }))
                
                window.rootViewController?.present(alert,
                                                   animated: true,
                                                   completion: nil)
                
            })
            .disposed(by: producer.disposeBag)
        
        return true
    }
}
