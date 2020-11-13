//
//  BannerView.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class BannerView: UIView {
    public static var shared: BannerViewProtocol?
    
    static let bannerHeight: CGFloat = 70
    static let animationDuration: TimeInterval = 0.75
    static let appearanceDuration: TimeInterval = 2
    
    public class func show(
        bannerContentView: BannerViewProtocol,
        in viewController: UIViewController,
        alwaysPresented: Bool = true,
        completed: (() -> Void)? = nil
    ) {
        guard let rootView = viewController.navigationController?.view ?? viewController.view else { return }
        
        BannerView.shared?.removeFromSuperview()
        
        var navBarHeight: CGFloat = 0
        if !rootView.subviews.contains(bannerContentView) {
            if let navigationVC = viewController.navigationController {
                navBarHeight = navigationVC.navigationBar.isHidden ? 0 : navigationVC.navigationBar.frame.height
                
                rootView.insertSubview(bannerContentView,
                                       belowSubview: navigationVC.navigationBar)
            } else {
                rootView.addSubview(bannerContentView)
            }
        }
        
        bannerContentView.frame = CGRect(x: 0,
                                         y: -bannerHeight - rootView.safeAreaInsets.top,
                                         width: rootView.frame.width,
                                         height: bannerHeight)
        bannerContentView.layoutIfNeeded()
        
        let topConstraint = NSLayoutConstraint(item: bannerContentView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: rootView.safeAreaLayoutGuide,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 0 - navBarHeight - bannerHeight - rootView.safeAreaInsets.top)
        
        bannerContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topConstraint,
            bannerContentView.leftAnchor.constraint(equalTo: rootView.leftAnchor),
            bannerContentView.rightAnchor.constraint(equalTo: rootView.rightAnchor),
            bannerContentView.heightAnchor.constraint(equalToConstant: bannerHeight + rootView.safeAreaInsets.top * 0.5)
        ])
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut,
                       animations: {
                           topConstraint.constant = -rootView.safeAreaInsets.top
                           rootView.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: appearanceDuration,
                       delay: 5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut,
                       animations: {
                           if !alwaysPresented {
                               topConstraint.constant = -3 * bannerHeight
                               rootView.layoutIfNeeded()
                           }
                       },
                       completion: { isCompleted in
                           if isCompleted, !alwaysPresented {
                               completed?()
                               bannerContentView.removeFromSuperview()
                           }
        })
        
        BannerView.shared = bannerContentView
    }
}
