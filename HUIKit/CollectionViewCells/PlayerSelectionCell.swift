//
//  ItemSelectionCell.swift
//  HUIKit
//
//  Created by Jean Victor on 3/4/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class PlayerSelectionCell: UICollectionViewCell {
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    public lazy var currentHoleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var teeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    public lazy var teeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    public lazy var greenButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    public lazy var greenLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    public lazy var dividerView: UIView = {
        let separator = UIView()
        return separator
    }()
    
    public lazy var nameContainerView: UIView = {
        UIView()
    }()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layout()
    }
    
    private func layout() {
        [nameContainerView,
         teeButton,
         greenButton,
         dividerView,
         teeLabel,
         greenLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        
        [nameLabel,
         currentHoleLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                nameContainerView.addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            nameContainerView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                       constant: 20),
            nameContainerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: nameContainerView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: nameContainerView.leftAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 150),
            nameLabel.bottomAnchor.constraint(equalTo: nameContainerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            currentHoleLabel.leftAnchor.constraint(equalTo: nameContainerView.leftAnchor),
            currentHoleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            currentHoleLabel.widthAnchor.constraint(equalToConstant: 150),
            currentHoleLabel.bottomAnchor.constraint(equalTo: nameContainerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            teeButton.rightAnchor.constraint(equalTo: dividerView.leftAnchor, constant: -10),
            teeButton.widthAnchor.constraint(equalToConstant: 50),
            teeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            teeLabel.rightAnchor.constraint(equalTo: dividerView.leftAnchor, constant: -10),
            teeLabel.topAnchor.constraint(equalTo: teeButton.bottomAnchor),
            teeLabel.widthAnchor.constraint(equalToConstant: 50),
            teeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            dividerView.rightAnchor.constraint(equalTo: greenButton.leftAnchor, constant: -10),
            dividerView.widthAnchor.constraint(equalToConstant: 1),
            dividerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            greenButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            greenButton.widthAnchor.constraint(equalToConstant: 50),
            greenButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            greenLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            greenLabel.topAnchor.constraint(equalTo: greenButton.bottomAnchor),
            greenLabel.widthAnchor.constraint(equalToConstant: 50),
            greenLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
