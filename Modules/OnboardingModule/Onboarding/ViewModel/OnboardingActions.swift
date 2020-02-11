//
//  OnboardingActions.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import HFoundation

enum OnboardingUIAction: EventProtocol {
    case actionTypeTapped(OnboardingDatasourceType)
}

enum OnboardingModelAction: EventProtocol { }

enum OnboardingActions: EventProtocol {
    case ui(OnboardingUIAction)
    case model(OnboardingModelAction)
}
