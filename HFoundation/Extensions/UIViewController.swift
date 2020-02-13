//
//  UIViewController.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public extension UIViewController {
    func setBackgroundImage(_ image: UIImage) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = image
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage,
                           at: 0)
    }
}
