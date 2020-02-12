//
//  OnboardingState.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import HFoundation

enum OnboardingState: CaseAccessible, Equatable {
    case pages([OnboardingPage])
    
    static func reduce(_ state: OnboardingState,
                       action: OnboardingUIAction)-> OnboardingState {
        switch (state, action) {
        // Not changing state
        case (.pages(_),
              .actionTypeTapped(_)): return state
        }
    }
    
    static func reduce(_ state: OnboardingState,
                       model: OnboardingModelAction)-> OnboardingState {
        state
    }
}
