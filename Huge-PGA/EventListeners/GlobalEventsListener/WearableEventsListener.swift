//
//  WearableEventsListener.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/13/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

class WearableEventsListener: EventsListener {
    func listenEvents(from producer: AnyEventsProducer,
                      events: Observable<WearableManagerEvents>) -> Bool {
        producer.capture(event: WearableManagerEvents.bluetoothStatusChanged)
            .toRoutableObservable()
            .filter { $0 == .denied }
            .subscribe(onNext: { status in
                print("[DEBUG] - bluetooth status changed - \(status.rawValue)")
                guard let window = UIApplication.shared.windows.first else { return }
                
                let alert = UIAlertController(title: "Whoops",
                                              message: "It looks like bluetooth services disabled. Please enable them in settings.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Open Settings",
                                              style: UIAlertAction.Style.default,
                                              handler: { _ in
                                                  guard let bundleId = Bundle.main.bundleIdentifier,
                                                      let url = URL(string: "\(UIApplication.openSettingsURLString)&path=Bluetooth/\(bundleId)") else { return }
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
