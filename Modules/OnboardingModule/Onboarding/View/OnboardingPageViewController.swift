//
//  OnboardingPageViewController.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit
import HFoundation

enum OnboardingComponentType: Int {
    case image
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
        
        generatePageDatasource(for: page)
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func generatePageDatasource(for page: OnboardingPage) {
        var datasource: [OnboardingComponentType: UIView] = [:]
         
        datasource[.image] = generateTitleImageView(with: page.image)
        datasource[.title] = generateTitle(with: page.title)
        datasource[.button] = generateButton(with: page.buttonDatasource.title)
        datasource[.description] = generateDescription(with: page.details)
        
        pageView.datasource = datasource
    }
    
    private func layout() {
        view.addSubview(pageView)
        
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: view.topAnchor),
            pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension OnboardingPageViewController {
    func generateTitleImageView(with image: UIImage)-> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }
    
    func generateTitle(with copy: String)-> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = copy
        label.textColor = .white
        return label
    }
    
    func generateDescription(with copy: String? = nil)-> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = copy ?? ""
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    func generateButton(with title: String,
                        icon: UIImage? = nil)-> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        return button
    }
}
