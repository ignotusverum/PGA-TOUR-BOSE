//
//  OnboardingViewModel.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

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
        transform(input: input,
                  scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<OnboardingUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<OnboardingState> {
        Observable.feedbackLoop(initialState: .pages(model.pages),
                                scheduler: scheduler,
                                reduce: { (state, action) -> OnboardingState in
                                    switch action {
                                    case let .ui(action): return .reduce(state, action: action)
                                    case let .model(action): return .reduce(state, model: action)
                                    }
        }, feedback: { _ in input.map(OnboardingActions.ui) })
            .sendSideEffects({ _ in
                Observable.merge(
                    input.capture(case: OnboardingUIAction.actionTypeTapped)
                        .map(OnboardingModuleEvents.actionTypeTapped),
                    input.capture(case: OnboardingUIAction.changedToType)
                        .map(OnboardingModuleEvents.changedToType)
                )
            }, to: events.asObserver())
    }
}
