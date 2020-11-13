//
//  GlobalConfig.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import RxCocoa
import RxSwift

public enum GlobalConfigKeys: String {
    case readoutConfig
}

public class GlobalConfig {
    public static var readout: ReadoutConfig {
        guard let data = UserDefaults.standard.value(forKey: GlobalConfigKeys.readoutConfig.rawValue) as? Data,
            let decodedReadoutConfig = try? PropertyListDecoder().decode(ReadoutConfig.self, from: data) else {
            return ReadoutConfig()
        }
        
        return decodedReadoutConfig
    }
    
    public private(set) static var readoutObservable: Observable<ReadoutConfig> = {
        UserDefaults.standard.rx.observe(ReadoutConfig.self, GlobalConfigKeys.readoutConfig.rawValue)
            .unwrap()
            .distinctUntilChanged()
            .share(replay: 1,
                   scope: .whileConnected)
    }()
    
    public static var readoutBinder: Binder<ReadoutConfig> = {
        Binder(UserDefaults.standard) { defaults, readout in
            print("[ReadoutConfig] didSet from selector")
            defaults.set(readout,
                         forKey: GlobalConfigKeys.readoutConfig.rawValue)
        }
    }()
}

public struct ReadoutConfig: Decodable, Equatable {
    public var par: Bool
    public var yardage: Bool
    public var players: Bool
    public var holeNumber: Bool
    
    public init(par: Bool = true,
                yardage: Bool = true,
                players: Bool = true,
                holeNumber: Bool = true) {
        self.par = par
        self.yardage = yardage
        self.players = players
        self.holeNumber = holeNumber
    }
}
