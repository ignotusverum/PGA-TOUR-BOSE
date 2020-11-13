//
//  InterestListViewModel.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/8/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

protocol InterestsViewModelProtocol {
    func transform(input: Observable<InterestsUIAction>) -> Observable<InterestsState>
    func transform(input: Observable<InterestsUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<InterestsState>
}

class InterestsViewModel: InterestsViewModelProtocol {
    let model: InterestsModel
    let events: PublishSubject<InterestsModuleEvents>
    
    init(model: InterestsModel,
         events: PublishSubject<InterestsModuleEvents>) {
        self.model = model
        self.events = events
    }
    
    func transform(input: Observable<InterestsUIAction>) -> Observable<InterestsState> {
        transform(input: input,
                  scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<InterestsUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<InterestsState> {
        let errors = PublishSubject<Error>()
        
        return Observable.feedbackLoop(initialState: InterestsState.loading(whileInState: nil),
                                       scheduler: scheduler,
                                       reduce: { (state, action) -> InterestsState in
                                           switch action {
                                           case let .ui(action): return .reduce(state, action: action)
                                           case let .model(action): return .reduce(state, model: action)
                                           }
                                       }, feedback: { _ in input.map(InterestsActions.ui) },
                                       weakify(self,
                                               default: .empty()) { (me: InterestsViewModel, state) in
                                           Observable.merge(state.capture(case: InterestsState.loading).toVoid()
                                               .compactFlatMapLatest { _ in me.model
                                                   .loadInterests()
                                                   .asObservable()
                                                   .map(InterestsModelAction.loaded)
                                               },
                                                            errors.map(InterestsModelAction.error))
                                               .map(InterestsActions.model)
        })
            .sendSideEffects({ _ in
                Observable.merge(
                    input.capture(case: InterestsUIAction.interestSelected)
                        .map(InterestsModuleEvents.interestSelected)
                )
            }, to: events.asObserver())
    }
}
