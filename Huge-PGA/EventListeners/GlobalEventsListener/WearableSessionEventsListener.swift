//
//  WearableSessionEventsListener.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/13/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

class WearableSessionEventsListener: EventsListener {
    var suspensionOverlay: SuspensionOverlay?
    
    func listenEvents(from producer: AnyEventsProducer,
                      events: Observable<WearableSessionManagerEvents>) -> Bool {
        producer.capture(event: WearableSessionManagerEvents.device)
            .compactMap { $0 }
            .toRoutableObservable()
            .subscribe(onNext: { device in
                guard let window = UIApplication.shared.windows.first,
                    let rootController = window.rootViewController else { return }
                
                let deviceName = device.name ?? "Unknown device"
                rootController.showBanner(title: "Connected to \"\(deviceName)\"",
                                          type: .info,
                                          alwaysPresented: false)
            })
            .disposed(by: producer.disposeBag)
        
        producer.capture(event: WearableSessionManagerEvents.didClose)
            .toRoutableObservable()
            .subscribe(onNext: { eventType in
                self.suspensionOverlay?.removeFromSuperview()
            })
            .disposed(by: producer.disposeBag)
        
        producer.capture(event: WearableSessionManagerEvents.event)
            .toRoutableObservable()
            .subscribe(onNext: { eventType in
                guard let window = UIApplication.shared.windows.first,
                    let rootController = window.rootViewController else { return }
                
                switch eventType {
                case .didSuspendWearableSensorService(let reason):
                    self.suspensionOverlay = SuspensionOverlay.add(to: rootController.view,
                                                                   reason: reason)
                default:
                    self.suspensionOverlay?.removeFromSuperview()
                }
            })
            .disposed(by: producer.disposeBag)
        
        producer.capture(event: WearableSessionManagerEvents.didClose)
            .toRoutableObservable()
            .subscribe(onNext: { error in
                guard let window = UIApplication.shared.windows.first,
                    let rootController = window.rootViewController else { return }
                let copy = error?.localizedDescription ?? "Device disconnected."
                
                rootController.showBanner(title: copy,
                                          type: .notConnected,
                                          alwaysPresented: true,
                                          onTapHandler: {
                                              print("[DEBUG] - reconnect tapped")
                                              WearableSessionManager.shared.session = nil
                                              WearableManager.createConnection()
                                                  .subscribeOn(MainScheduler.asyncInstance)
                                                  .subscribe(onSuccess: {
                                                      print("[DEBUG] - device info changed - \($0)")
                                                  })
                                                  .disposed(by: producer.disposeBag)
                })
            })
            .disposed(by: producer.disposeBag)
        
        producer.capture(event: WearableSessionManagerEvents.trueHeadingDegreesChanged)
            .toRoutableObservable()
            .compactMap { $0 }
            .subscribe(onNext: { rotationDegrees in
                print("[DEBUG] - Rotation degrees - \(rotationDegrees)")
            })
            .disposed(by: producer.disposeBag)
        
        return true
    }
}
