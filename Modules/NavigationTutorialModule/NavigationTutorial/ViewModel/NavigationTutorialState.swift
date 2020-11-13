//
//  NavigationTutorialState.swift
//  NavigationTutorialModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum NavigationTutorialState: CaseAccessible, Equatable {
    case pages([NavigationTutorialPage])
    
    static func reduce(_ state: NavigationTutorialState,
                       action: NavigationTutorialUIAction) -> NavigationTutorialState {
        switch (state, action) {
        // Not changing state
        case (.pages(_),
              .changedToType(_)): return state
        }
    }
    
    static func reduce(_ state: NavigationTutorialState,
                       model: NavigationTutorialModelAction) -> NavigationTutorialState {
        state
    }
}
