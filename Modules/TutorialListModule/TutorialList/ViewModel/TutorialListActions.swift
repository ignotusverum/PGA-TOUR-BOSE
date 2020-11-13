//
//  TutorialListActions.swift
//  TutorialListModule
//
//  Created by Vlad Z. on 2/15/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

enum TutorialListUIAction: EventProtocol {
    case actionTypeTapped(TutorialActionType)
}

enum TutorialListModelAction: EventProtocol {}

enum TutorialListActions: EventProtocol {
    case ui(TutorialListUIAction)
    case model(TutorialListModelAction)
}
