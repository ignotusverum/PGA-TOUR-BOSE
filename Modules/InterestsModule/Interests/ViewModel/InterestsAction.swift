//
//  InterestListAction.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/8/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum InterestsUIAction: EventProtocol {
    case reload
    case interestSelected(Double, Double, String)
}

enum InterestsModelAction: EventProtocol {
    case loaded(_ interests: [Interest])
    case error(_ error: Error)
}

enum InterestsActions: EventProtocol {
    case ui(InterestsUIAction)
    case model(InterestsModelAction)
}
