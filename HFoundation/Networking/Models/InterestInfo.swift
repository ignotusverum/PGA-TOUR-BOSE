//
//  InterestInfo.swift
//  HFoundation
//
//  Created by Jean Victor on 3/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct InterestInfo: Decodable {
    let holeNumber: Int
    let par: Int
    let yards: Int
    
    public var formattedHoleNumber: String {
        if (holeNumber == 1) {
            return "1st"
        } else if (holeNumber == 2) {
            return "2nd"
        } else if (holeNumber == 3) {
            return "3rd"
        } else {
            return "\(holeNumber)th"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case holeNumber = "hole_number"
        case par
        case yards
    }
}
