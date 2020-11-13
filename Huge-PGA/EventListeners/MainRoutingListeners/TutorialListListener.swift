//
//  TutorialListListener.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/15/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

class TutorialListListener: ModuleEventsListener {
    var router: Router
    init(_ router: Router) {
        self.router = router
    }
    
    func listenEvents(from module: AnyEventsProducerModule,
                      events: Observable<TutorialListRouteEvent>) -> Bool {
        events.capture(case: TutorialListRouteEvent.actionTypeTapped)
            .toRoutableObservable()
            .subscribe(onNext: { action in
                switch action {
                case .discovery:
                    let step = PresentableRoutingStep(
                        withStep: .discoveryTutorial(),
                        presentationMode: .push(withCloseButton: .none),
                        beforePresenting: { $0.hidesBottomBarWhenPushed = true }
                    )
                    
                    self.router.route(to: step)
                case .navigation:
                    let step = PresentableRoutingStep(
                        withStep: .navigationTutorial(),
                        presentationMode: .push(withCloseButton: .none),
                        beforePresenting: { $0.hidesBottomBarWhenPushed = true }
                    )
                    
                    self.router.route(to: step)
                default:
                    let step = PresentableRoutingStep(
                        withStep: .home(),
                        presentationMode: .push(withCloseButton: .none),
                        beforePresenting: { $0.hidesBottomBarWhenPushed = true }
                    )
                    
                    self.router.route(to: step)
                }
            })
            .disposed(by: module.disposeBag)
        return true
    }
}
