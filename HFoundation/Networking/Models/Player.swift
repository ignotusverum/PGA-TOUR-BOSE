//
//  Player.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/21/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Player: Decodable, Identifiable {
    public let id: String
    public let isAmateur: String
    public let lfFull: String
    public let lfName: String
    public let flName: String
    public let hometown: String
    public let officialMoneyRank: String
    public let shortName: String
    public let countryCode: String
    public let currentPosition: String
    public let totalScore: String
    public let status: String?
    public let lastHoleCompleted: String
    
    public var currentHole: String {
        if (lastHoleCompleted == "18") {
            return "F"
        }
        if (lastHoleCompleted == "") {
            return "1"
        }
        let completedHole = Int(lastHoleCompleted) ?? 0
        return String(completedHole)
    }
    
    public var nextHole: Int {
        if (lastHoleCompleted == "18") {
            return -1
        }
        if (lastHoleCompleted == "") {
            return -1
        }
        let nextHole = Int(lastHoleCompleted)! + 1
        return nextHole
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "TournamentPlayerID"
        case isAmateur = "IsAmateur"
        case lfFull = "LFFull"
        case lfName = "LFName"
        case flName = "FLName"
        case hometown = "Hometown"
        case officialMoneyRank = "OfficialMoneyRank"
        case shortName = "ShortName"
        case countryCode = "CountryCode"
        case currentPosition = "CurrentPosition"
        case totalScore = "TotalScore"
        case status = "Status"
        case lastHoleCompleted = "LastHoleCompleted"
    }
}
