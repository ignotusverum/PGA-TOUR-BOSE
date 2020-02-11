//
//  TabbarControllerRouter.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

class TabBarControllerRouter: Router {
    var viewControllersFactory: ViewControllersFactory?
    
    init(withFactory factory: ViewControllersFactory) {
        viewControllersFactory = factory
    }
    
    lazy var topViewController: UIViewController = {
        let launchSB = UIStoryboard(name: "LaunchScreen", bundle: nil)
        return launchSB.instantiateViewController(withIdentifier: "LaunchScreen")
    }()
    
    let topViewControllerReady = BehaviorRelay(value: false)
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func rootViewController(forLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> UIViewController? {
        let tabbarController = UITabBarController()
        guard let viewControllerFactory = viewControllersFactory else { return tabbarController }
        
        let matchesNavigationController = UINavigationController(rootViewController: UIViewController())
        tabbarController.viewControllers = [matchesNavigationController]
        
        AppDelegate.shared.window?.transitionToRootController(tabbarController)
        
        return tabbarController
    }
    
    func showLoadingView() {}
    func hideLoadingView() {}
    func handleShortcutItem(_ item: UIApplicationShortcutItem) {}
}

extension UIWindow {
    func transitionToRootController(_ viewController: UIViewController, completed: @escaping () -> Void = {}) {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            let oldState = UIView.areAnimationsEnabled
            
            UIView.setAnimationsEnabled(false)
            
            self.rootViewController = viewController
            self.makeKeyAndVisible()
            
            UIView.setAnimationsEnabled(oldState)
        }) { finished in
            completed()
        }
    }
}

