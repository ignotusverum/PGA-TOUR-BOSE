//
//  TournamentAdapter+Config.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/21/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation

extension TournamentAdapter:
    MainAPIConfigurable,
    NetworkingConfigurable,
    TournamentAPIConfigurable {
    public static func configurator() {
        TournamentAdapter(config: AdapterConfig(base: baseURL,
                                                name: apiConfig.path))
    }
}
