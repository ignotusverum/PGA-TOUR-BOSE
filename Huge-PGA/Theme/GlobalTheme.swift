//
//  GlobalTheme.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import ThemeManager
import UIKit

private extension ThemeColorPalette {
    var color: UIColor {
        switch self {
        case .white: return .white
        case .grey100: return .color(fromHex: "#eff0ef")
        case .grey300: return .color(fromHex: "#9c9b9e")
        case .black: return .color(fromHex: "#000000")
        case .primary: return .color(fromHex: "#003771")
        case .error: return .color(fromHex: "#EF0A00")
        case .success: return .color(fromHex: "#45e588")
        }
    }
}

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}

private extension ThemeFontAttribute {
    func roboto(withSize size: CGFloat = UIFont.labelFontSize) -> UIFont {
        switch self {
        case .regular: return .robotoCondensed(size)
        case .bold: return .robotoCondensedBold(size)
        }
    }
}

private extension ThemeFontStyle {
    var fontSize: CGFloat {
        switch self {
        case .small: return 11
        case .title: return 18
        case .subtitle: return 15
        case .headline: return 30
        case .navigationTitle: return 20
        }
    }
    
    var font: UIFont {
        attribute.roboto(withSize: fontSize)
    }
    
    var kern: CGFloat {
        switch self {
        case .title: return 1.18
        default: return 0
        }
    }
}

class GlobalTheme: ThemeProtocol {
    lazy var appearanceRules: AppearanceRuleSet = {
        let isRegularRegular = UIScreen.main.traitCollection.verticalSizeClass == .regular &&
            UIScreen.main.traitCollection.horizontalSizeClass == .regular
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor: color(forColorPalette: .black),
            NSAttributedString.Key.font: font(forStyle: .subtitle(attribute: .regular))
        ]
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = color(forColorPalette: .black)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: color(forColorPalette: .black),
            NSAttributedString.Key.font: font(forStyle: .subtitle(attribute: .regular))
        ], for: .normal)
        
        return AppearanceRuleSet {
            PropertyAppearanceRule<UINavigationBar, UIColor?>(keypath: \.tintColor, value: color(forColorPalette: .primary))
            UINavigationBar[\.barTintColor, color(forColorPalette: .primary)]
            UINavigationBar[\.titleTextAttributes, [
                NSAttributedString.Key.foregroundColor: color(forColorPalette: .white),
                NSAttributedString.Key.font: font(forStyle: .navigationTitle(attribute: .bold))
            ]]
        }
    }()
    
    func color(forColorPalette colorPalette: ThemeColorPalette) -> UIColor {
        return colorPalette.color
    }
    
    func font(forStyle style: ThemeFontStyle) -> UIFont {
        return style.font
    }
    
    func kern(forStyle style: ThemeFontStyle) -> CGFloat {
        return style.kern
    }
    
    @discardableResult
    func configure(label: UILabel,
                   withStyle style: ThemeFontStyle,
                   customizing: ((UILabel, ThemeProtocol) -> Void)?) -> UILabel {
        label.font = style.font
        label.textColor = color(forColorPalette: .black)
        
        customizing?(label, self)
        
        return label
    }
}
