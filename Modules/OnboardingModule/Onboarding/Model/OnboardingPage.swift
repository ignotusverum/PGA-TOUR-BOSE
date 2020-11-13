//
//  OnboardingDatasource.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin
import UIKit

public enum OnboardingDatasourceType {
    case location
    case bluetooth
    case confirm
}

struct OnboardingButtonDatasource: Equatable {
    var title: String
    var image: UIImage?
    
    init(title: String,
         image: UIImage? = nil) {
        self.title = title
        self.image = image
    }
}

struct OnboardingPage: Equatable {
    var title: String
    var image: UIImage
    var details: String?
    var type: OnboardingDatasourceType
    var buttonDatasource: OnboardingButtonDatasource
    
    init(title: String,
         image: UIImage,
         type: OnboardingDatasourceType,
         buttonDatasource: OnboardingButtonDatasource,
         details: String? = nil) {
        self.title = title
        self.image = image
        self.type = type
        self.buttonDatasource = buttonDatasource
        self.details = details
    }
}
