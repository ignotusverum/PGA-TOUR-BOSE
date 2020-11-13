//
//  APIConfig.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

public struct APIConfig {
    public var path: String
    
    public init(path: String) {
        self.path = path
    }
}

enum MainAPIConfig {
    case tournament
    
    func config() -> APIConfig {
        switch self {
        case .tournament: return APIConfig(path: "r")
        }
    }
}

public protocol MainAPIConfigurable where Self: NetworkingConfigurable {
    static var apiConfig: APIConfig { get }
}
