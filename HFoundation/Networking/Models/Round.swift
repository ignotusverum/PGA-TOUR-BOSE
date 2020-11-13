//
//  Round.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/21/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Round: Decodable {
    public let number: String
    let state: String
    let scoringFormatCode: String
    let maxPlayersPerGroup: String
    let isCutRound: String
    let isPlayoff: String
    let isTeeTimeRevised: String
    public let groups: [Group]
    
    enum CodingKeys: String, CodingKey {
        case number = "RoundNumber"
        case state = "RoundState"
        case scoringFormatCode = "ScoringFormatCode"
        case maxPlayersPerGroup = "MaxPlayersPerGroup"
        case isCutRound = "IsCutRound"
        case isPlayoff = "IsPlayOff"
        case isTeeTimeRevised = "IsTeeTimeRevised"
        case groups = "Group"
    }
}
