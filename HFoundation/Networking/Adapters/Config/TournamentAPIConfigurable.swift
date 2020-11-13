//
//  ProductsAPIConfigurable.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

public protocol TournamentAPIConfigurable where Self: MainAPIConfigurable {}

public extension TournamentAPIConfigurable {
    static var apiConfig: APIConfig { MainAPIConfig.tournament.config() }
}
