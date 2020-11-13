//
//  TitleActionCell.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class TitleActionCell: UICollectionViewCell {
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    public lazy var actionButton: UIButton = {
        UIButton()
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layout()
    }
    
    private func layout() {
        [titleLabel,
         actionButton,
         descriptionLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 120),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                              constant: 50),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor,
                                                  constant: 14),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
