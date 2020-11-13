//
//  PlayerListViewModel.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/3/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

protocol PlayerListViewModelProtocol {
    func transform(input: Observable<PlayerListUIAction>) -> Observable<PlayerListState>
    func transform(input: Observable<PlayerListUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<PlayerListState>
}

class PlayerListViewModel: PlayerListViewModelProtocol {
    let model: PlayerListModel
    let events: PublishSubject<PlayerListModuleEvents>
    
    init(model: PlayerListModel,
         events: PublishSubject<PlayerListModuleEvents>) {
        self.model = model
        self.events = events
    }
    
    func transform(input: Observable<PlayerListUIAction>) -> Observable<PlayerListState> {
        transform(input: input,
                  scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<PlayerListUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<PlayerListState> {
        let errors = PublishSubject<Error>()
        
        return Observable.feedbackLoop(initialState: PlayerListState.loading(whileInState: nil),
                                       scheduler: scheduler,
                                       reduce: { (state, action) -> PlayerListState in
                                           switch action {
                                           case let .ui(action): return .reduce(state, action: action)
                                           case let .model(action): return .reduce(state, model: action)
                                           }
                                       }, feedback: { _ in input.map(PlayerListActions.ui) },
                                       weakify(self,
                                               default: .empty()) { (me: PlayerListViewModel, state) in
                                           Observable.merge(state.capture(case: PlayerListState.loading).toVoid()
                                               .compactFlatMapLatest { _ in me.model
                                                   .fetchPlayers()
                                                   .asObservable()
                                                   .catchError(sendTo: errors)
                                                   .map(PlayerListModelAction.loaded)
                                               },
                                                            errors.map(PlayerListModelAction.error))
                                               .map(PlayerListActions.model)
        })
            .sendSideEffects({ _ in
                Observable.merge(
                    input.capture(case: PlayerListUIAction.playerSelected)
                        .map(PlayerListModuleEvents.playerSelected)
                )
            }, to: events.asObserver())
    }
}
