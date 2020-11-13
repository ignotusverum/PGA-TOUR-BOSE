//
//  TitleActionCell+Theme.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import UIKit
import ThemeManager

public extension TitleActionCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        titleLabel.applyLabelStyle(.headline(attribute: .bold),
                                   usingTheme: theme,
                                   customizing:{ (label, _) in
                                    label.textColor = .color(forPalette: .white)
        })
        
        actionButton.titleLabel?.applyLabelStyle(.title(attribute: .regular),
                                                 usingTheme: theme)
        
        actionButton.tintColor = .color(forPalette: .primary)
        actionButton.backgroundColor = .color(forPalette: .white)
        actionButton.setTitleColor(.color(forPalette: .primary), for: .normal)
        
        actionButton.layer.cornerRadius = 6
        actionButton.layer.masksToBounds = true
        
        actionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -35, bottom: 0, right: 0)
        
        descriptionLabel.applyLabelStyle(.subtitle(attribute: .regular),
                                         usingTheme: theme,
                                         customizing:{ (label, _) in
                                            label.textColor = .color(forPalette: .grey300)
        })
    }
}
