//
//  DiscoveryTutorialModule.swift
//  DiscoveryTutorialModule
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

public class DiscoveryTutorialModuleContext: ModuleContextProtocol {
    public typealias ModuleType = DiscoveryTutorialModule
    public var routingContext: String
    
    public init(routingContext: String) {
        self.routingContext = routingContext
    }
    
    public func make() -> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum DiscoveryTutorialModuleEvents: EventProtocol {
    case changedToType(DiscoveryTutorialType)
}

public class DiscoveryTutorialModule: ModuleProtocol, EventsProducer {
    public var events: Observable<DiscoveryTutorialModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<DiscoveryTutorialModuleEvents>()
    
    public var context: DiscoveryTutorialModuleContext
    
    public required init(usingContext buildContext: DiscoveryTutorialModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        let model = DiscoveryTutorialModel()
        let viewModel = DiscoveryTutorialViewModel(model: model,
                                                   events: _events)
        let view = DiscoveryTutorialViewController(with: viewModel)
        return view
    }
}
