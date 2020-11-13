//
//  SharedProtocol.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/13/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public protocol SharedProtocol {
    associatedtype SharedType
    static var shared: SharedType { get }
}
