//
//  Group.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/21/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Group: Decodable {
    let id: String
    let startTime: String
    let morningStart: String
    let startTee: String
    public let players: [Player]
    
    enum CodingKeys: String, CodingKey {
        case id = "GroupID"
        case players = "Player"
        case startTime = "StartTime"
        case morningStart = "MorningStart"
        case startTee = "StartTee"
    }
}
