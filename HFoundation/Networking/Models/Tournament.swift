//
//  Tournament.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/21/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Tournament: Decodable {
    let id: String
    let name: String
    let tourType: String
    public let event: Event
    
    enum CodingKeys: String, CodingKey {
        case id = "TournamentID"
        case name = "TournamentName"
        case tourType = "TournamentTourType"
        case event = "Event"
    }
}
