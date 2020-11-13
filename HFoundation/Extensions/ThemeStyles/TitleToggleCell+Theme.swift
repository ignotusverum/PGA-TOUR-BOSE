//
//  TitleToggleCell+Theme.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import ThemeManager
import UIKit

public extension TitleToggleCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        titleLabel.applyLabelStyle(.title(attribute: .regular), customizing: { label, _ in
            label.textColor = .color(forPalette: .grey300)
        })
        
        toggle.onTintColor = .color(forPalette: .primary)
    }
}
