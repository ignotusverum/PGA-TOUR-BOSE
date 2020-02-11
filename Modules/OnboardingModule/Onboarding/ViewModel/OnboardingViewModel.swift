//
//  OnboardingViewModel.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import HFoundation

protocol OnboardingViewModelProtocol {
    func transform(input: Observable<OnboardingUIAction>) -> Observable<OnboardingState>
    func transform(input: Observable<OnboardingUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<OnboardingState>
}

class OnboardingViewModel: OnboardingViewModelProtocol {
    let model: OnboardingModel
    let events: PublishSubject<OnboardingModuleEvents>
    
    init(model: OnboardingModel,
         events: PublishSubject<OnboardingModuleEvents>) {
        self.model = model
        self.events = events
    }
    
    func transform(input: Observable<OnboardingUIAction>) -> Observable<OnboardingState> {
        return transform(input: input,
                         scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<OnboardingUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<OnboardingState> {
        Observable.feedbackLoop(initialState: .pages([]),
                                scheduler: scheduler,
                                reduce: { (state, action) -> OnboardingState in
                                    switch action {
                                    case let .ui(action): return .reduce(state, action: action)
                                    case let .model(action): return .reduce(state, model: action)
                                    }
        }, feedback: { _ in input.map(OnboardingActions.ui) },
           weakify(self,
                   default: .empty()) { (me: OnboardingViewModel, state) in
                    .empty()
        })
            .sendSideEffects({ state in
                input.capture(case: OnboardingUIAction.actionTypeTapped)
                    .map(OnboardingModuleEvents.actionTypeTapped)
            }, to: events.asObserver())
    }
}

