//
//  InterestAdapter.swift
//  HFoundation
//
//  Created by Jean Victor on 3/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation
import RxSwift

public protocol InterestAdapterProtocol {
    static func loadJson(fileName: String) -> Observable<[Interest]>
}

public class InterestAdapter {
    private static var adapter: InterestAdapter!
    
    @discardableResult
    public init() {
        InterestAdapter.adapter = self
    }
    
    public static func fetch(jsonFile: String) -> Observable<[Interest]> {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: nil) else {
            fatalError("Failed to locate \(jsonFile) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(jsonFile) from bundle.")
        }
        
        guard let interests = try? JSONDecoder().decode([Interest].self, from: data) else {
            fatalError("Failed to decode \(jsonFile) from bundle.")
        }
        return Observable.just(interests)
    }
}
