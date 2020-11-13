//
//  Coordinates.swift
//  HFoundation
//
//  Created by Jean Victor on 3/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Coordinates: Decodable {
    public let lat: Double
    public let lng: Double
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lng = "long"
    }
}
