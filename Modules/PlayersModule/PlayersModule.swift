//
//  PlayersModule.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/2/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

public class PlayersModuleContext: ModuleContextProtocol {
    public typealias ModuleType = PlayersModule
    
    public var tournamentId: Int
    public var routingContext: String
    
    public init(routingContext: String,
                tournamentId: Int) {
        self.routingContext = routingContext
        self.tournamentId = tournamentId
    }
    
    public func make() -> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum PlayerListModuleEvents: EventProtocol {
    case playerSelected(Int, String)
}

public class PlayersModule: ModuleProtocol, EventsProducer {
    public var events: Observable<PlayerListModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<PlayerListModuleEvents>()
    
    public var context: PlayersModuleContext
    
    public required init(usingContext buildContext: PlayersModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        let model = PlayerListModel(tournamentId: context.tournamentId)
        let viewModel = PlayerListViewModel(model: model,
                                            events: _events)
        let view = PlayerListViewController(with: viewModel)
        return view
    }
}
