//
//  IconTitleCell.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class IconTitleCell: UICollectionViewCell {
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    public lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layout()
    }
    
    private func layout() {
        [titleLabel,
         leftImageView,
         rightImageView]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: 25),
            leftImageView.widthAnchor.constraint(equalToConstant: 25),
            leftImageView.heightAnchor.constraint(equalToConstant: 25),
            leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor,
                                                constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor,
                                                 constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            rightImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -25),
            rightImageView.widthAnchor.constraint(equalToConstant: 25),
            rightImageView.heightAnchor.constraint(equalToConstant: 25),
            rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
