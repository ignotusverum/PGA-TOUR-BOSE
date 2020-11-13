//
//  HomeModule.swift
//  HomeModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

public class HomeModuleContext: ModuleContextProtocol {
    public typealias ModuleType = HomeModule
    public var routingContext: String
    
    public init(routingContext: String) {
        self.routingContext = routingContext
    }
    
    public func make() -> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum HomeModuleEvents: EventProtocol {
    case findPlayerTapped
    case pointsOfInterestsTapped
}

public class HomeModule: ModuleProtocol, EventsProducer {
    public var events: Observable<HomeModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<HomeModuleEvents>()
    
    public var context: HomeModuleContext
    
    public required init(usingContext buildContext: HomeModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        let model = HomeModel()
        let viewModel = HomeViewModel(model: model,
                                      events: _events)
        let view = HomeViewController(with: viewModel)
        return view
    }
}
