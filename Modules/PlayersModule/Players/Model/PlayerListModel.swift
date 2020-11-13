//
//  PlayerListModel.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/3/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import RxSwift

protocol PlayerListModelProtocol {
    func fetchPlayers() -> Single<Tournament>
}

struct PlayerListModel: PlayerListModelProtocol {
    let adapter = TournamentAdapter.self
    
    var tournamentId: Int
    init(tournamentId: Int) {
        self.tournamentId = tournamentId
    }
    
    func fetchPlayers() -> Single<Tournament> {
        adapter.fetch(id: tournamentId)
    }
}
