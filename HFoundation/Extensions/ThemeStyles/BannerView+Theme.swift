//
//  BannerView+Theme.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/15/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import ThemeManager
import UIKit

public extension BannerViewProtocol {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = theme.color(forColorPalette: .black)
        
        titleLabel.textColor = theme.color(forColorPalette: .grey300)
        titleLabel.font = theme.font(forStyle: .subtitle(attribute: .regular))
        
        setBorder(.bottom,
                  withColor: .color(forPalette: .grey300),
                  andThickness: 1.0)
        
        switch type {
        case .info:
            leftView.tintColor = .color(forPalette: .grey100)
        case .notConnected:
            leftView.tintColor = .color(forPalette: .grey300)
        }
    }
}
