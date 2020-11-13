//
//  NavigationTutorialActions.swift
//  NavigationTutorialModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum NavigationTutorialUIAction: EventProtocol {
    case changedToType(NavigatoinTutorialType)
}

enum NavigationTutorialModelAction: EventProtocol {}

enum NavigationTutorialActions: EventProtocol {
    case ui(NavigationTutorialUIAction)
    case model(NavigationTutorialModelAction)
}
