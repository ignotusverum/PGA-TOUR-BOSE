//
//  ItemSelectionView+Theme.swift
//  HFoundation
//
//  Created by Jean Victor on 3/4/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import ThemeManager
import UIKit

public extension PlayerSelectionCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = .clear
        
        let lightGreyColor = UIColor(red: 0.60, green: 0.71, blue: 0.79, alpha: 1.0)
        let font: UIFont = UIFont.boldSystemFont(ofSize: 13)
        let smallFont: UIFont = UIFont.boldSystemFont(ofSize: 9)
        
        nameLabel.applyLabelStyle(.title(attribute: .regular), customizing: { label, _ in
            label.textColor = .white
            label.font = font
        })
        
        currentHoleLabel.textColor = lightGreyColor
        currentHoleLabel.font = smallFont
        teeButton.setTitleColor(.white, for: .normal)
        teeButton.titleLabel?.font = font
        teeLabel.textColor = lightGreyColor
        teeLabel.font = smallFont
        greenButton.setTitleColor(.white, for: .normal)
        greenButton.titleLabel?.font = font
        greenLabel.textColor = lightGreyColor
        greenLabel.font = smallFont
        dividerView.backgroundColor = lightGreyColor
        
        setBorder(.bottom,
                  withColor: lightGreyColor,
                  andThickness: 0.20)
    }
}

public extension PlayerSingleSelectionCell {
    func applyTheme(usingTheme theme: ThemeProtocol = ThemeContainer.defaultTheme) {
        backgroundColor = .clear
        
        let lightGreyColor = UIColor(red: 0.60, green: 0.71, blue: 0.79, alpha: 1.0)
        let font: UIFont = UIFont.boldSystemFont(ofSize: 13)
        
        nameLabel.applyLabelStyle(.title(attribute: .regular), customizing: { label, _ in
            label.textColor = .white
            label.font = font
        })
        
        detailsLabel.textColor = .color(forPalette: .white)
        detailsLabel.font = font
        
        setBorder(.bottom,
                  withColor: lightGreyColor,
                  andThickness: 0.20)
    }
}
