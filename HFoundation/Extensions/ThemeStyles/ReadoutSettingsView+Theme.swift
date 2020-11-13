//
//  ReadoutSettingsView+Theme.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import ThemeManager
import UIKit

public extension ReadoutSettingsView {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = .color(forPalette: .white)
        collectionView.backgroundColor = .color(forPalette: .white)
        
        titleLabel.applyLabelStyle(.title(attribute: .regular), customizing: { label, _ in
            label.textColor = .color(forPalette: .black)
        })
        
        layer.cornerRadius = 10
        collectionView.layer.cornerRadius = 10
        
        titleLabel.setBorder(.bottom,
                             withColor: .color(forPalette: .grey300),
                             andThickness: 1)
    }
}
