//
//  NetworkingConfigurable.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

public protocol NetworkingConfigurable {
    static var baseURL: String { get }
}

public extension MainAPIConfigurable {
    static var baseURL: String { "statdata.pgatour.com" }
}
