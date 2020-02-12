//
//  OnboardingPageViewController.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

import ThemeManager
import Hero
import HFoundation

enum OnboardingComponentType: Int {
    case title
    case button
    case description
}

class OnboardingPageViewController: UIViewController {
    var page: OnboardingPage
    var pageView = OnboardingPageView() <~ {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(_ page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHeroEnabled = true
        generatePageDatasource(for: page)
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func generatePageDatasource(for page: OnboardingPage) {
        var datasource: [OnboardingComponentType: UIView] = [:]
         
        datasource[.title] = generateTitle(with: page.title)
        datasource[.button] = generateButton(with: page.buttonDatasource.title)
        datasource[.description] = generateDescription(with: page.details)
        
        pageView.datasource = datasource
    }
    
    private func layout() {
        view.addSubview(pageView)
        
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 450),
            pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension OnboardingPageViewController {
    func generateTitle(with copy: String)-> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = copy
        label.textColor = .white
        label.font = .font(forStyle: .headline(attribute: .bold))
        return label
    }
    
    func generateDescription(with copy: String? = nil)-> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = copy ?? ""
        label.textAlignment = .center
        label.textColor = .color(forPalette: .grey300)
        label.font = .font(forStyle: .subtitle(attribute: .bold))
        return label
    }
    
    func generateButton(with title: String,
                        icon: UIImage? = nil)-> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .color(forPalette: .white)
        button.layer.cornerRadius = 8
        button.setTitleColor(.color(forPalette: .primary), for: .normal)
        return button
    }
}
