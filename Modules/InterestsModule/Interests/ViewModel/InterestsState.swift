//
//  InterestListModel.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/8/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum InterestsState: CaseAccessible, Equatable {
    case interests([Interest])
    
    indirect case loading(whileInState: InterestsState?)
    indirect case error(Error, whileInState: InterestsState)
    
    static func reduce(_ state: InterestsState,
                       action: InterestsUIAction) -> InterestsState {
        switch (state, action) {
        case let (.loading(aState), _):
            return .loading(whileInState: aState)
        case (.interests, _):
            return state
        default: return state
        }
    }
    
    static func reduce(_ state: InterestsState,
                       model: InterestsModelAction) -> InterestsState {
        switch (state, model) {
        case (_, .loaded(let newDatasource)):
            let interests = newDatasource.self
            print("Num interests: \(interests.count)")
            return .interests(interests)
        case (_, let .error(error)):
            return .error(error, whileInState: state)
        }
    }
    
    static func == (lhs: InterestsState, rhs: InterestsState) -> Bool {
        switch (lhs, rhs) {
        case let (.interests(lInterest), .interests(rInterest)): return lInterest == rInterest
        case let (.loading(lState), .loading(rState)): return lState == rState
        case let (.error(lError, lState), .error(rError, rState)):
            return lError.localizedDescription == rError.localizedDescription && lState == rState
        default: return false
        }
    }
}
