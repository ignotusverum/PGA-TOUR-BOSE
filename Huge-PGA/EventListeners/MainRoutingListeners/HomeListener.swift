//
//  HomeListener.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

import CoreLocation

class HomeListener: ModuleEventsListener {
    var router: Router
    init(_ router: Router) {
        self.router = router
    }
    
    func listenEvents(from module: AnyEventsProducerModule,
                      events: Observable<HomeRouteEvents>) -> Bool {
        events.capture(case: HomeRouteEvents.findPlayerTapped)
            .toRoutableObservable()
            .subscribe(onNext: { [weak module] _ in
                guard let module = module,
                    let _ = module.rootViewController?.navigationController else { return }
                
                let step = PresentableRoutingStep(
                    withStep: .playerList(),
                    presentationMode: .push(withCloseButton: .image(Asset.iconBack.image,
                                                                    onClose: { module.rootViewController?.navigationController?.popViewController(animated: true)
                    }))
                )
                self.router.route(to: step)
            })
            .disposed(by: module.disposeBag)
        
        events.capture(case: HomeRouteEvents.pointsOfInterestsTapped)
            .toRoutableObservable()
            .subscribe(onNext: { [weak module] _ in
                guard let module = module,
                    let _ = module.rootViewController?.navigationController else { return }
                
                let step = PresentableRoutingStep(
                    withStep: .interestList(),
                    presentationMode: .push(withCloseButton: .image(Asset.iconBack.image,
                                                                    onClose: { module.rootViewController?.navigationController?.popViewController(animated: true)
                    }))
                )
                self.router.route(to: step)
            })
            .disposed(by: module.disposeBag)
        
        return true
    }
}
