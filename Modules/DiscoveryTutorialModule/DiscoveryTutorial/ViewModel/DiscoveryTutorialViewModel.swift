//
//  DiscoveryTutorialViewModel.swift
//  DiscoveryTutorialModule
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

protocol DiscoveryTutorialViewModelProtocol {
    func transform(input: Observable<DiscoveryTutorialUIAction>) -> Observable<DiscoveryTutorialState>
    func transform(input: Observable<DiscoveryTutorialUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<DiscoveryTutorialState>
}

class DiscoveryTutorialViewModel: DiscoveryTutorialViewModelProtocol {
    let model: DiscoveryTutorialModel
    let events: PublishSubject<DiscoveryTutorialModuleEvents>
    
    init(model: DiscoveryTutorialModel,
         events: PublishSubject<DiscoveryTutorialModuleEvents>) {
        self.model = model
        self.events = events
    }
    
    func transform(input: Observable<DiscoveryTutorialUIAction>) -> Observable<DiscoveryTutorialState> {
        transform(input: input,
                  scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<DiscoveryTutorialUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<DiscoveryTutorialState> {
        Observable.feedbackLoop(initialState: .pages(model.pages),
                                scheduler: scheduler,
                                reduce: { (state, action) -> DiscoveryTutorialState in
                                    switch action {
                                    case let .ui(action): return .reduce(state, action: action)
                                    case let .model(action): return .reduce(state, model: action)
                                    }
        }, feedback: { _ in input.map(DiscoveryTutorialActions.ui) })
            .sendSideEffects({ _ in
                input.capture(case: DiscoveryTutorialUIAction.changedToType)
                    .map(DiscoveryTutorialModuleEvents.changedToType)
            }, to: events.asObserver())
    }
}
