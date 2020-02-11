//
//  OnboardingViewController.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

import HUIKit
import HFoundation

class OnboardingViewController: PageViewController {
    let disposeBag = DisposeBag()
    
    let viewModel: OnboardingViewModel
    private let actions = PublishSubject<OnboardingUIAction>()
    
    init(with viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(items: [])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
