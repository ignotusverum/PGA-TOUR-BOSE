//
//  TitleViewCell.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class CustomViewCell: UICollectionViewCell {
    public var customView = UIView() {
        didSet {
            layout()
        }
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
            customView.topAnchor.constraint(equalTo: topAnchor),
            customView.bottomAnchor.constraint(equalTo: bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
