//
//  Event.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/21/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Event: Decodable {
    let id: String
    public let course: Course
    let numberOfRounds: String
    
    enum CodingKeys: String, CodingKey {
        case id = "EventID"
        case course = "Course"
        case numberOfRounds = "NumberOfRounds"
    }
}
