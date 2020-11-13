//
//  PlayerSingleSelectionCell.swift
//  HUIKit
//
//  Created by Vlad Z. on 3/17/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class PlayerSingleSelectionCell: UICollectionViewCell {
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    public lazy var detailsLabel: UILabel = {
        UILabel()
    }()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layout()
    }
    
    private func layout() {
        [nameLabel,
         detailsLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor,
                                            constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 150),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.rightAnchor.constraint(equalTo: rightAnchor,
                                                constant: -20),
            detailsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailsLabel.widthAnchor.constraint(equalToConstant: 50),
            detailsLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
