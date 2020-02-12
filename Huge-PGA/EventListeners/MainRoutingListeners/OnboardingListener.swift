//
//  OnboardingListener.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

class OnboardingListener: ModuleEventsListener {
    var router: Router
    init(_ router: Router) {
        self.router = router
    }
    
    func listenEvents(from module: AnyEventsProducerModule,
                      events: Observable<OnboardingRouteEvent>) -> Bool {
                
        events.capture(case: OnboardingRouteEvent.actionTypeTapped)
            .toRoutableObservable()
            .subscribe(onNext: { pageType in
                print("pageType - \(pageType)")
            })
            .disposed(by: module.disposeBag)
        
        return true
    }
}

