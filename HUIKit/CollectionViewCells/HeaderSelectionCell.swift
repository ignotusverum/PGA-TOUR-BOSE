//
//  HeaderSelectionCell.swift
//  HUIKit
//
//  Created by Jean Victor on 3/16/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class HeaderSelectionCell: UICollectionViewCell {
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layout()
    }
    
    private func layout() {
        [nameLabel,
         locationLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            locationLabel.widthAnchor.constraint(equalToConstant: 100),
            locationLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
