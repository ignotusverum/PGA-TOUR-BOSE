//
//  UIFontExtension.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public extension UIFont {
    // MARK: - Font Registration
    
    static func robotoCondensed(_ size: CGFloat) -> UIFont {
        return loadCustomFont(font: FontFamily.RobotoCondensed.regular,
                              withSize: size)
    }
    
    static func robotoCondensedLight(_ size: CGFloat) -> UIFont {
        return loadCustomFont(font: FontFamily.RobotoCondensed.light,
                              withSize: size)
    }
    
    static func robotoCondensedBold(_ size: CGFloat) -> UIFont {
        return loadCustomFont(font: FontFamily.RobotoCondensed.bold,
                              withSize: size)
    }
    
    private static func loadCustomFont(font: FontConvertible,
                                       withSize size: CGFloat = UIFont.labelFontSize) -> UIFont {
        guard let customFont = UIFont(font: font, size: size) else { fatalError() }
        return UIFontMetrics.default.scaledFont(for: customFont)
    }
}

