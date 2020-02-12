//
//  UIButton+Setters.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit
import ThemeManager

extension UIButton {
    func setupTitle(font: UIFont) -> UIButton {
        titleLabel?.font = font
        titleLabel?.textAlignment = .center
        return self
    }
    
    @discardableResult
    func setupLayer(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor?) -> UIButton {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        layer.masksToBounds = true
        
        return self
    }
    
    @discardableResult
    func resetBackgrounds() -> UIButton {
        setBackgroundImage(nil, for: [.normal, .disabled, .highlighted, .focused])
        return self
    }
    
    @discardableResult
    func setBackgroundColor(color: UIColor, for state: UIControl.State) -> UIButton {
        backgroundColor = .clear
        setBackgroundImage(color.toImage(), for: state)
        return self
    }
    
    @discardableResult
    func setTitleTextColor(color: UIColor, for state: UIControl.State) -> UIButton {
        setTitleColor(color, for: state)
        return self
    }
}

