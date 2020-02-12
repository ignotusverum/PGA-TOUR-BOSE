//
//  OnboardingPageView.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit
import HFoundation

class OnboardingPageView: UIView {
    var datasource: [OnboardingComponentType: UIView] {
        didSet {
            setup(for: stackView)
        }
    }
    
    let scrollView = UIScrollView()
    
    let stackView = UIStackView() <~ {
        $0.spacing = 0
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
    }
    
    init(datasource: [OnboardingComponentType: UIView] = [:]) {
        self.datasource = datasource
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layout()
    }
    
    private func layout() {
        addSubview(stackView)
        
        layout(stackView: stackView,
               scrollView: scrollView)
    }
    
    private func layout(stackView: UIStackView,
                        scrollView: UIScrollView) {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        backgroundColor = UIColor.init(patternImage: Asset.gradientBackground.image)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                            constant: 90),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    func setup(for stackView: UIStackView) {
        let sortedDatasource = datasource.sorted(by: { $0.0.rawValue < $1.0.rawValue })
        for item in sortedDatasource {
            guard let view = datasource[item.key] else { return }
            
            addStackItem(view,
                         type: item.key,
                         stackView: stackView)
            
            switch item.key {
            case .image:
                NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: 260)])
                stackView.setCustomSpacing(120,
                                           after: view)
            case .title,
                 .button,
                 .description:
                stackView.setCustomSpacing(40.0,
                                           after: view)
            }
        }
        
        stackView.setNeedsLayout()
    }
    
    func addStackItem(_ item: UIView,
                      type: OnboardingComponentType,
                      stackView: UIStackView) {
        stackView.addArrangedSubview(item)
        item.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .image:
            NSLayoutConstraint.activate([
                item.rightAnchor.constraint(equalTo: stackView.rightAnchor),
                item.widthAnchor.constraint(equalTo: stackView.widthAnchor,
                                            multiplier: 0.85)
            ])
            
        default:
            NSLayoutConstraint.activate([
                item.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
                item.widthAnchor.constraint(equalToConstant: stackView.frame.width)
            ])
        }
    }
}

