//
//  UIViewController+Banner.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/15/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import UIKit

public extension UIViewController {
    func showBanner(title: String,
                    type: BannerType,
                    alwaysPresented: Bool,
                    in viewController: UIViewController? = nil,
                    completed: (() -> Void)? = nil,
                    onTapHandler: (() -> Void)? = nil) {
        var bannerContentView: BannerViewProtocol
        switch type {
        case .info: bannerContentView = InfoBannerView(title: title)
        case .notConnected:
            
            let notConnectedView = NotConnectedBannerView(title: title)
            notConnectedView.onTap = {
                onTapHandler?()
            }
            
            bannerContentView = notConnectedView
        }
        
        BannerView.show(bannerContentView: bannerContentView,
                        in: viewController ?? self,
                        alwaysPresented: alwaysPresented,
                        completed: completed)
        
        BannerView.shared?.applyTheme()
    }
}
