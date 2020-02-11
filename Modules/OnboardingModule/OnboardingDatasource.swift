//
//  OnboardingDatasource.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit
import MERLin

public enum OnboardingDatasourceType {
    case location
    case bluetooth
    case confirm
}

public struct OnboardingButtonDatasource {
    var title: String
    var image: UIImage?
    var handleTap: PublishSubject<Void>
    
    public init(title: String,
                image: UIImage? = nil,
                handleTap: PublishSubject<Void> = PublishSubject()) {
        self.title = title
        self.image = image
        self.handleTap = handleTap
    }
}

public struct OnboardingDatasource {
    var title: String
    var image: UIImage
    var details: String?
    var type: OnboardingDatasourceType
    var buttonDatasource: OnboardingButtonDatasource
    
    public init(title: String,
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
