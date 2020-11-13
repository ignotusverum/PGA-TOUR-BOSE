//
//  IconTitleCell+Theme.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import ThemeManager
import UIKit

public extension IconTitleCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = .clear
        
        titleLabel.applyLabelStyle(.title(attribute: .regular), customizing: { label, _ in
            label.textColor = .color(forPalette: .white)
        })
        
        leftImageView.tintColor = .color(forPalette: .white)
        rightImageView.tintColor = .color(forPalette: .white)
        
        layer.borderWidth = 2
        layer.cornerRadius = 10
        layer.borderColor = UIColor.color(forPalette: .white).cgColor
    }
}
