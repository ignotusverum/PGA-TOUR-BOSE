//
//  UIPageControl.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class PageControl: UIPageControl {
    var borderColor: UIColor = .clear
    
    override public var currentPage: Int {
        didSet {
            updateBorderColor()
        }
    }
    
    func updateBorderColor() {
        subviews.enumerated().forEach { index, subview in
            if index != currentPage {
                subview.layer.borderColor = borderColor.cgColor
                subview.layer.borderWidth = 1
            } else {
                subview.layer.borderWidth = 0
            }
        }
    }
    
}
