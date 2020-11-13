//
//  UIViewController.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public extension UIViewController {
    func showLoading(title: String? = nil) {
        let alert = UIAlertController(title: nil, message: title ?? "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}

public extension UIView {
    func setBackgroundImage(_ image: UIImage) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = image
        backgroundImage.contentMode = .scaleAspectFill
        insertSubview(backgroundImage,
                      at: 0)
    }
}
