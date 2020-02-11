//
//  ConfigureOperator.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

infix operator <~: AdditionPrecedence
public func <~ <T>(lhs: T, configurator: (inout T) -> Void) -> T {
    var lhs = lhs
    configurator(&lhs)
    return lhs
}
