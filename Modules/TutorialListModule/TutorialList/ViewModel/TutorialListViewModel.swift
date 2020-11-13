//
//  TutorialListViewModel.swift
//  TutorialListModule
//
//  Created by Vlad Z. on 2/15/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

protocol TutorialListViewModelProtocol {
    func transform(input: Observable<TutorialListUIAction>) -> Observable<TutorialListState>
    func transform(input: Observable<TutorialListUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<TutorialListState>
}

class TutorialListViewModel: TutorialListViewModelProtocol {
    let model: TutorialListModel
    let events: PublishSubject<TutorialListModuleEvents>
    
    init(model: TutorialListModel,
         events: PublishSubject<TutorialListModuleEvents>) {
        self.model = model
        self.events = events
    }
    
    func transform(input: Observable<TutorialListUIAction>) -> Observable<TutorialListState> {
        transform(input: input,
                  scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<TutorialListUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<TutorialListState> {
        Observable.feedbackLoop(initialState: .items(model.items),
                                scheduler: scheduler,
                                reduce: { (state, action) -> TutorialListState in
                                    switch action {
                                    case let .ui(action): return .reduce(state,
                                                                         action: action)
                                    case let .model(action): return .reduce(state,
                                                                            model: action)
                                    }
        }, feedback: { _ in input.map(TutorialListActions.ui) })
            .sendSideEffects({ _ in
                input.capture(case: TutorialListUIAction.actionTypeTapped)
                    .map(TutorialListModuleEvents.actionTypeTapped)
            }, to: events.asObserver())
    }
}
