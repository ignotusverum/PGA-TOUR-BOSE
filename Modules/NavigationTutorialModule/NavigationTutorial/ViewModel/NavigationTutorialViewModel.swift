//
//  NavigationTutorialViewModel.swift
//  NavigationTutorialModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

protocol NavigationTutorialViewModelProtocol {
    func transform(input: Observable<NavigationTutorialUIAction>) -> Observable<NavigationTutorialState>
    func transform(input: Observable<NavigationTutorialUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<NavigationTutorialState>
}

class NavigationTutorialViewModel: NavigationTutorialViewModelProtocol {
    let model: NavigationTutorialModel
    let events: PublishSubject<NavigationTutorialModuleEvents>
    
    init(model: NavigationTutorialModel,
         events: PublishSubject<NavigationTutorialModuleEvents>) {
        self.model = model
        self.events = events
    }
    
    func transform(input: Observable<NavigationTutorialUIAction>) -> Observable<NavigationTutorialState> {
        transform(input: input,
                  scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<NavigationTutorialUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<NavigationTutorialState> {
        Observable.feedbackLoop(initialState: .pages(model.pages),
                                scheduler: scheduler,
                                reduce: { (state, action) -> NavigationTutorialState in
                                    switch action {
                                    case let .ui(action): return .reduce(state, action: action)
                                    case let .model(action): return .reduce(state, model: action)
                                    }
        }, feedback: { _ in input.map(NavigationTutorialActions.ui) })
            .sendSideEffects({ _ in
                input.capture(case: NavigationTutorialUIAction.changedToType)
                    .map(NavigationTutorialModuleEvents.changedToType)
            }, to: events.asObserver())
    }
}
