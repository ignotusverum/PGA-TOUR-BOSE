//
//  TitleToggleCell.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class TitleToggleCell: UICollectionViewCell {
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    public lazy var toggle: UISwitch = { UISwitch() }()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layout()
    }
    
    private func layout() {
        [titleLabel,
         toggle]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            toggle.centerYAnchor.constraint(equalTo: centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -25),
            toggle.heightAnchor.constraint(equalToConstant: 31),
            toggle.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: 25)
        ])
    }
}
