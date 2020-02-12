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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = Asset.gradientBackground.image
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage,
                           at: 0)
        
        let headerImage = generateTitleImageView(with: viewModel.model.pages.first!.image)
        headerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerImage)
        
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                             constant: 130),
            headerImage.heightAnchor.constraint(equalToConstant: 230),
            headerImage.widthAnchor.constraint(equalTo: view.widthAnchor,
                                               multiplier: 0.85),
            headerImage.rightAnchor.constraint(equalTo: view.rightAnchor,
                                               constant: 15)
        ])
        
        bindViewModel()
    }
    
    func generateTitleImageView(with image: UIImage)-> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        return imageView
    }
    
    
    private func bindViewModel() {
        let states = viewModel.transform(input: actions).publish()
        states.capture(case: OnboardingState.pages)
            .take(1)
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] pages in
                guard let self = self else { return }
                
                let controllers = pages.map { OnboardingPageViewController($0, actions: self.actions) }
                self.configure(with: controllers)
            })
            .disposed(by: disposeBag)
        
        states.connect()
            .disposed(by: disposeBag)
    }
}
