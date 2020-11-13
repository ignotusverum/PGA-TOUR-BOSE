//
//  DiscoveryTutorialActions.swift
//  DiscoveryTutorialModule
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

public enum DiscoveryTutorialType: Equatable {
    case settings
    case presentation
}

enum DiscoveryTutorialUIAction: EventProtocol {
    case changedToType(DiscoveryTutorialType)
}

enum DiscoveryTutorialModelAction: EventProtocol {}

enum DiscoveryTutorialActions: EventProtocol {
    case ui(DiscoveryTutorialUIAction)
    case model(DiscoveryTutorialModelAction)
}
