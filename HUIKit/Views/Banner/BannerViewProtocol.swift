//
//  BannerViewProtocol.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public enum BannerType {
    case info
    case notConnected
}

public protocol BannerViewProtocol where Self: UIView {
    var type: BannerType { get }
    var title: String { get }
    var titleLabel: UILabel { get }
    var leftView: UIView { get set }
    var rightView: UIView { get set }
}

public extension BannerViewProtocol {
    func layout() {
        [titleLabel,
         leftView,
         rightView].forEach { addSubview($0) }
        
        leftView.translatesAutoresizingMaskIntoConstraints = false
        rightView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftView.leftAnchor.constraint(equalTo: leftAnchor,
                                           constant: 20),
            leftView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                             constant: -20),
            leftView.heightAnchor.constraint(equalToConstant: 20),
            leftView.widthAnchor.constraint(equalToConstant: 12)
        ])
        
        NSLayoutConstraint.activate([
            rightView.rightAnchor.constraint(equalTo: rightAnchor,
                                             constant: -20),
            rightView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -20),
            rightView.heightAnchor.constraint(equalToConstant: 20),
            rightView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: -20),
            titleLabel.leftAnchor.constraint(equalTo: leftView.rightAnchor,
                                             constant: 15),
            titleLabel.rightAnchor.constraint(equalTo: rightView.leftAnchor,
                                              constant: -5),
            titleLabel.centerYAnchor.constraint(equalTo: leftView.centerYAnchor)
        ])
    }
}
