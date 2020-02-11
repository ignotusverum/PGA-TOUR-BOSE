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
    
    private func bindViewModel() {
        let states = viewModel.transform(input: actions).publish()
        
        states.capture(case: OnboardingState.pages)
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] pages in
                guard let self = self else { return }
                
                let controllers = pages.map { OnboardingPageViewController(datasource: $0) }
                self.configure(with: controllers)
            })
            .disposed(by: disposeBag)
    }
}
