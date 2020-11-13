//
//  HoleSelectionCell.swift
//  HUIKit
//
//  Created by Jean Victor on 3/16/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class HoleSelectionCell: UICollectionViewCell {
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var teeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    public lazy var greenButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    public lazy var dividerView: UIView = {
        let separator = UIView()
        return separator
    }()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layout()
    }
    
    private func layout() {
        [teeButton,
         greenButton,
         nameLabel,
         dividerView]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 80),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            teeButton.rightAnchor.constraint(equalTo: dividerView.leftAnchor, constant: -10),
            teeButton.widthAnchor.constraint(equalToConstant: 70),
            teeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            teeButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dividerView.rightAnchor.constraint(equalTo: greenButton.leftAnchor, constant: -10),
            dividerView.widthAnchor.constraint(equalToConstant: 1),
            dividerView.heightAnchor.constraint(equalToConstant: 20),
            dividerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            greenButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            greenButton.widthAnchor.constraint(equalToConstant: 70),
            greenButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            greenButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        teeButton.isHidden = false
        dividerView.isHidden = false
    }
}
