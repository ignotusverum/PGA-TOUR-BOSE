//
//  CustomScaledview.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class CustomScaledViewCell: UICollectionViewCell {
    public var customView = UIView() {
        didSet { layout() }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        customView.removeFromSuperview()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layout()
    }
    
    private func layout() {
        customView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: topAnchor,
                                            constant: -135),
            customView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: 135),
            customView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: 90)
        ])
    }
}
