//
//  DiscoveryTutorialState.swift
//  DiscoveryTutorialModule
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum DiscoveryTutorialState: CaseAccessible, Equatable {
    case pages([DiscoveryTutorialPage])
    
    static func reduce(_ state: DiscoveryTutorialState,
                       action: DiscoveryTutorialUIAction) -> DiscoveryTutorialState {
        switch (state, action) {
        // Not changing state
        case (.pages(_),
              .changedToType(_)): return state
        }
    }
    
    static func reduce(_ state: DiscoveryTutorialState,
                       model: DiscoveryTutorialModelAction) -> DiscoveryTutorialState {
        state
    }
}
