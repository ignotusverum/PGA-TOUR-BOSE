//
//  InterestModule.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/8/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

public class InterestsModuleContext: ModuleContextProtocol {
    public typealias ModuleType = InterestsModule
    
    public var fileName: String
    public var routingContext: String
    
    public init(routingContext: String,
                fileName: String) {
        self.routingContext = routingContext
        self.fileName = fileName
    }
    
    public func make() -> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum InterestsModuleEvents: EventProtocol {
    case interestSelected(Double, Double, String)
}

public class InterestsModule: ModuleProtocol, EventsProducer {
    public var events: Observable<InterestsModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<InterestsModuleEvents>()
    
    public var context: InterestsModuleContext
    
    public required init(usingContext buildContext: InterestsModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        let model = InterestsModel(fileName: context.fileName)
        let viewModel = InterestsViewModel(model: model,
                                           events: _events)
        let view = InterestsViewController(with: viewModel)
        return view
    }
}
