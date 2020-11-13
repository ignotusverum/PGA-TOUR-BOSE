//
//  TutorialListModule.swift
//  TutorialListModule
//
//  Created by Vlad Z. on 2/15/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

public class TutorialListModuleContext: ModuleContextProtocol {
    public typealias ModuleType = TutorialListModule
    public var routingContext: String
    
    public init(routingContext: String) {
        self.routingContext = routingContext
    }
    
    public func make() -> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum TutorialActionType {
    case skip
    case discovery
    case navigation
}

public enum TutorialListModuleEvents: EventProtocol {
    case actionTypeTapped(TutorialActionType)
}

public class TutorialListModule: ModuleProtocol, EventsProducer {
    public var events: Observable<TutorialListModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<TutorialListModuleEvents>()
    
    public var context: TutorialListModuleContext
    
    public required init(usingContext buildContext: TutorialListModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        let model = TutorialListModel()
        let viewModel = TutorialListViewModel(model: model,
                                              events: _events)
        let view = TutorialListViewController(with: viewModel)
        return view
    }
}
