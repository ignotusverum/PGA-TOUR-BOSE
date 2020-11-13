//
//  ActionCardCell+Theme.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/17/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import ThemeManager
import UIKit

public extension ActionCardCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = .color(forPalette: .white)
        iconImageView.tintColor = .color(forPalette: .grey300)
        
        titleLabel.applyLabelStyle(.title(attribute: .bold),
                                   usingTheme: theme) { (label, _) in
            label.textColor = .color(forPalette: .black)
        }
        
        descriptionLabel.applyLabelStyle(.title(attribute: .regular),
                                         usingTheme: theme) { (label, _) in
            label.textColor = .color(forPalette: .grey300)
        }
        
        actionIconImageView.tintColor = .color(forPalette: .black)
        
        layer.cornerRadius = 10
    }
}
