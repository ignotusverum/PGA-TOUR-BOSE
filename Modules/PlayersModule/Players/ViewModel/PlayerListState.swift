//
//  PlayerListState.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/3/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum PlayerListState: CaseAccessible, Equatable {
    case players([Player])
    
    indirect case loading(whileInState: PlayerListState?)
    indirect case error(Error, whileInState: PlayerListState)
    
    static func reduce(_ state: PlayerListState,
                       action: PlayerListUIAction) -> PlayerListState {
        switch (state, action) {
        // Not changing state
        case let (.loading(aState), .reload):
            return .loading(whileInState: aState)
        case (.players, .reload):
            return .loading(whileInState: state)
        default: return state
        }
    }
    
    static func reduce(_ state: PlayerListState,
                       model: PlayerListModelAction) -> PlayerListState {
        switch (state, model) {
        case (_, .loaded(let newDatasource)):
            let tournament = newDatasource.self
            let latestRound = tournament.event.course.rounds.max(by: {
                (a, b) -> Bool in
                b.number > a.number
            })
            print("Latest round: \(latestRound!.number)")
            
            let players = latestRound!.groups.flatMap { $0.players }.sorted(by: <)
            print("Num players: \(players.count)")
            
            return .players(players)
        case (_, let .error(error)):
            return .error(error, whileInState: state)
        }
    }
    
    static func == (lhs: PlayerListState, rhs: PlayerListState) -> Bool {
        switch (lhs, rhs) {
        case let (.players(lPlayers), .players(rPlayers)): return lPlayers == rPlayers
        case let (.loading(lState), .loading(rState)): return lState == rState
        case let (.error(lError, lState), .error(rError, rState)):
            return lError.localizedDescription == rError.localizedDescription && lState == rState
        default: return false
        }
    }
}
