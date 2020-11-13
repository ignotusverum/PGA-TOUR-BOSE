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
            .subscribe(onNext: { [weak module] pageType in
                guard let module = module,
                    let moduleRootNavigationController = module.rootViewController?.navigationController else { return }
                
                switch pageType {
                case .location:
                    LocationManager.shared.requestPermissions()
                case .bluetooth:
                    moduleRootNavigationController.showLoading()
                    
                    WearableManager.configure()
                    WearableManager.createConnection()
                        .observeOn(MainScheduler.asyncInstance)
                        .subscribe(onSuccess: {
                            moduleRootNavigationController.dismiss(animated: true, completion: nil)
                            WearableSessionManager.shared.session = $0
                        }, onError: { _ in moduleRootNavigationController.dismiss(animated: true, completion: nil) })
                        .disposed(by: module.disposeBag)
                case .confirm:
                    let step = PresentableRoutingStep(
                        withStep: .tutorialList(),
                        presentationMode: .push(withCloseButton: .none)
                    )
                    
                    self.router.route(to: step)
                }
            })
            .disposed(by: module.disposeBag)
        
        return true
    }
}
