//
//  TutorialListState.swift
//  TutorialListModule
//
//  Created by Vlad Z. on 2/15/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum TutorialListState: CaseAccessible, Equatable {
    case items([TutorialItem])
    
    static func reduce(_ state: TutorialListState,
                       action: TutorialListUIAction) -> TutorialListState {
        switch (state, action) {
        // Not changing state
        case (.items(_),
              .actionTypeTapped(_)): return state
        }
    }
    
    static func reduce(_ state: TutorialListState,
                       model: TutorialListModelAction) -> TutorialListState {
        state
    }
}
