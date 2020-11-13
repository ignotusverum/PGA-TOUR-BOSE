//
//  PaddingLabel.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class PaddingLabel: UILabel {
    public var topInset: CGFloat = 0
    public var rightInset: CGFloat = 0
    public var bottomInset: CGFloat = 0
    public var leftInset: CGFloat = 0
    
    public override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        setNeedsLayout()
        return super.drawText(in: rect.inset(by: insets))
    }
}
