//
//  EntitiesUtil.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import RxSwift
import XMLParsing

public extension PrimitiveSequence where Trait == SingleTrait, Element == Data {
    func decode<T: Decodable>(decoder: XMLDecoder? = nil) -> Single<T> {
        let defaultDecoder = XMLDecoder()
        
        return map {
            try (decoder ?? defaultDecoder)
                .decode(T.self, from: $0)
        }
    }
}
