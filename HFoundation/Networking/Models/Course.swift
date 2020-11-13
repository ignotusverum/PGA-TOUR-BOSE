//
//  Course.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/21/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Course: Decodable {
    let number: String
    let name: String
    let code: String
    let host: String
    let front: String
    let back: String
    let total: String
    public let rounds: [Round]
    
    enum CodingKeys: String, CodingKey {
        case number = "CourseNumber"
        case name = "CourseName"
        case code = "CourseCode"
        case host = "Host"
        case front = "Front"
        case back = "Back"
        case total = "Total"
        case rounds = "Round"
    }
}
