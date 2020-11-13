//
//  HomeViewModel.swift
//  HomeModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

protocol HomeViewModelProtocol {
    func transform(input: Observable<HomeUIAction>) -> Observable<HomeState>
    func transform(input: Observable<HomeUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<HomeState>
}

class HomeViewModel: HomeViewModelProtocol {
    let model: HomeModel
    let events: PublishSubject<HomeModuleEvents>
    
    init(model: HomeModel,
         events: PublishSubject<HomeModuleEvents>) {
        self.model = model
        self.events = events
    }
    
    func transform(input: Observable<HomeUIAction>) -> Observable<HomeState> {
        transform(input: input,
                  scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<HomeUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<HomeState> {
        Observable.feedbackLoop(initialState: .items(model.items),
                                scheduler: scheduler,
                                reduce: { (state, action) -> HomeState in
                                    switch action {
                                    case let .ui(action): return .reduce(state, action: action)
                                    case let .model(action): return .reduce(state, model: action)
                                    }
        }, feedback: { _ in input.map(HomeActions.ui) })
            .sendSideEffects({ _ in
                Observable.merge(
                    input.capture(case: HomeUIAction.findPlayerTapped)
                        .map { _ in HomeModuleEvents.findPlayerTapped },
                    input.capture(case: HomeUIAction.pointsOfInterestsTapped)
                        .map { _ in HomeModuleEvents.pointsOfInterestsTapped }
                )
            }, to: events.asObserver())
    }
}
