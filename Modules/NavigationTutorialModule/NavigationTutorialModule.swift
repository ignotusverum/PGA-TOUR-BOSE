//
//  NavigationTutorialModule.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

public enum NavigatoinTutorialType: Equatable {
    case player
    case frames
    case direction([String])
    case voice(Int)
}

public class NavigationTutorialModuleContext: ModuleContextProtocol {
    public typealias ModuleType = NavigationTutorialModule
    public var routingContext: String
    
    public init(routingContext: String) {
        self.routingContext = routingContext
    }
    
    public func make() -> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum NavigationTutorialModuleEvents: EventProtocol {
    case changedToType(NavigatoinTutorialType)
}

public class NavigationTutorialModule: ModuleProtocol, EventsProducer {
    public var events: Observable<NavigationTutorialModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<NavigationTutorialModuleEvents>()
    
    public var context: NavigationTutorialModuleContext
    
    public required init(usingContext buildContext: NavigationTutorialModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        let model = NavigationTutorialModel()
        let viewModel = NavigationTutorialViewModel(model: model,
                                                    events: _events)
        let view = NavigationTutorialViewController(with: viewModel)
        return view
    }
}
