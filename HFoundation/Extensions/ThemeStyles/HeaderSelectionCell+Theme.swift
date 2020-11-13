//
//  HeaderView+Theme.swift
//  HFoundation
//
//  Created by Jean Victor on 3/16/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import ThemeManager
import UIKit

public extension HeaderSelectionCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = .clear
        
        let lightGreyColor = UIColor(red: 0.60, green: 0.71, blue: 0.79, alpha: 1.0)
        let font: UIFont = UIFont.boldSystemFont(ofSize: 11)
        
        nameLabel.applyLabelStyle(.title(attribute: .regular), customizing: { label, _ in
            label.textColor = lightGreyColor
            label.font = font
        })
        
        locationLabel.applyLabelStyle(.title(attribute: .regular), customizing: { label, _ in
            label.textColor = lightGreyColor
            label.font = font
        })
    }
}
