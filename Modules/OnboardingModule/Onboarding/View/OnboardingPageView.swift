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
    var datasource: [OnboardingComponentType: UIView]
    
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
        
        backgroundColor = .white
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
    
    func setup(for stackView: UIStackView,
               view: UIView) {
        let sortedDatasource = datasource.sorted(by: { $0.0.rawValue < $1.0.rawValue })
        for item in sortedDatasource {
            guard let view = datasource[item.key] else { return }
            
            addStackItem(view,
                         to: stackView)
            
            switch item.key {
            case .image:
                NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: 260)])
            case .title,
                 .button,
                 .description:
                stackView.setCustomSpacing(30.0,
                                           after: view)
            }
        }
        
        stackView.setNeedsLayout()
    }
    
    func addStackItem(_ item: UIView,
                      to stackView: UIStackView) {
        stackView.addArrangedSubview(item)
        
        item.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            item.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            item.widthAnchor.constraint(equalToConstant: stackView.frame.width)
        ])
    }
}

