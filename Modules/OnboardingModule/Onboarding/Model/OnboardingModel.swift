//
//  OnboardingModel.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

struct OnboardingModel {
    var pages: [OnboardingPage] {
        [
            OnboardingPage(title: "Take your PGA Tour experience to the next level.",
                           image: Asset.iconGlasses.image,
                           type: .location,
                           buttonDatasource: OnboardingButtonDatasource(title: "Allow location access",
                                                                        image: Asset.iconLocation.image),
                           details: "When prompted, please select \"Always Allow"),
            OnboardingPage(title: "Please connect to your Bose Frames.",
                           image: Asset.iconGlasses.image,
                           type: .bluetooth,
                           buttonDatasource: OnboardingButtonDatasource(title: "Connect now",
                                                                        image: Asset.iconBluetooth.image)),
            OnboardingPage(title: "Successfully connected to Bose Frames.",
                           image: Asset.iconGlasses.image,
                           type: .confirm,
                           buttonDatasource: OnboardingButtonDatasource(title: "Continue"))
        ]
    }
}

