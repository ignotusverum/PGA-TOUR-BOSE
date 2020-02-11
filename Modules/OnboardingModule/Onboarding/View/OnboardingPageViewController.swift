//
//  OnboardingPageViewController.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit
import HFoundation

class OnboardingPageViewController: UIViewController {
    var datasource: OnboardingPage
    init(datasource: OnboardingPage) {
        self.datasource = datasource
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
