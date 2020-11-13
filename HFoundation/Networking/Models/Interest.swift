//
//  Interest.swift
//  HFoundation
//
//  Created by Jean Victor on 3/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Interest: Decodable, Identifiable {
    public let id: Int
    public let name: String
    public let type: String
    public let startCoords: Coordinates
    public let endCoords: Coordinates
    public let info: InterestInfo?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case startCoords = "start_coords"
        case endCoords = "end_coords"
        case info
    }
}
