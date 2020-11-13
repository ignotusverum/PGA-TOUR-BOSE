//
//  TournamentAdapter.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

import RxSwift

public protocol TournamentNetworkingProtocol where Self: NetworkingAdapter {
    static func fetch(id: Int) -> Single<Tournament>
}

public class TournamentAdapter: NetworkingAdapter {
    public var settings: AdapterConfig!
    private static var adapter: TournamentAdapter!
    
    @discardableResult
    public init(config: AdapterConfig) {
        settings = config
        TournamentAdapter.adapter = self
    }
}

extension TournamentAdapter: TournamentNetworkingProtocol {
    public static func fetch(id: Int) -> Single<Tournament> {
        let config = Requests
            .fetch(id)
            .configure
        
        return adapter
            .request(config)
            .decode()
    }
}

private extension TournamentAdapter {
    enum Requests: FrameAPIRequest {
        case fetch(Int)
        
        public var configure: RequestConfig {
            switch self {
            case .fetch(let id):
                return RequestConfig(method: .get,
                                     path: "\(id)/group_locator.xml")
            }
        }
    }
}
