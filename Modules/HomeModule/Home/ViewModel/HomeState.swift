//
//  HomeState.swift
//  HomeModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum HomeState: CaseAccessible, Equatable {
    case items([HomeItem])
    
    static func reduce(_ state: HomeState,
                       action: HomeUIAction) -> HomeState {
        state
    }
    
    static func reduce(_ state: HomeState,
                       model: HomeModelAction) -> HomeState {
        state
    }
}
