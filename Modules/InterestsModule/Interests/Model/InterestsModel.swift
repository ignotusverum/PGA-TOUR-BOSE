//
//  InterestListModel.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/8/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import RxSwift

protocol InterestsModelProtocol {
    func loadInterests() -> Observable<[Interest]>
}

struct InterestsModel: InterestsModelProtocol {
    let adapter = InterestAdapter.self
    
    var fileName: String
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func loadInterests() -> Observable<[Interest]> {
        return adapter.fetch(jsonFile: fileName)
    }
}
