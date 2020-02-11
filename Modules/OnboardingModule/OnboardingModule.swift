//
//  OnboardingModule.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import HFoundation

public class OnboardingModuleContext: ModuleContextProtocol {
    public typealias ModuleType = OnboardingModule
    public var routingContext: String
    
    public var datasource: [OnboardingPage]
    
    public init(routingContext: String,
                datasource: [OnboardingPage]) {
        self.datasource = datasource
        self.routingContext = routingContext
    }
    
    public func make()-> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum OnboardingModuleEvents: EventProtocol {
    case actionTypeTapped(OnboardingDatasourceType)
}

public class OnboardingModule: ModuleProtocol, EventsProducer {
    public var events: Observable<OnboardingModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<OnboardingModuleEvents>()
    
    public var context: OnboardingModuleContext
    
    public required init(usingContext buildContext: OnboardingModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        return UIViewController()
    }
}
