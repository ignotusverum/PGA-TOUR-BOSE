//
//  CardActionCardCell.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/16/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class ActionCardCell: UICollectionViewCell {
    public lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    public lazy var actionIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let containerView: UIView = UIView()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        containerView.backgroundColor = backgroundColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        
        [iconImageView,
         titleLabel,
         descriptionLabel,
         actionIconImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: 16),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: 24),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -24),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            actionIconImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                        constant: -15),
            actionIconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            actionIconImageView.widthAnchor.constraint(equalToConstant: 22),
            actionIconImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        titleLabel.sizeToFit()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: actionIconImageView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: actionIconImageView.trailingAnchor,
                                                       constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                     constant: -15)
        ])
    }
}
