//
//  TabbarControllerRouter.swift
//  Huge-PGA
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import MERLin

import CoreLocation
import RxCoreLocation

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
    
    func rootViewController(forLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> UIViewController? {
        guard let viewControllerFactory = viewControllersFactory else { return UIViewController() }
        
        let locationStatusObserver = LocationManager.shared
            .events.capture(case: LocationManagerEvents.locationStatusChanged)
            .filter({ $0 != .notDetermined })
            .take(1)
            .toVoid()
        
        let wearableSessionObserver = WearableSessionManager.shared
            .events.capture(case: WearableSessionManagerEvents.device)
            .compactMap { $0 }
            .take(1)
            .toVoid()
        
        let switchTonextPageObserver = Observable.merge(locationStatusObserver,
                                                        wearableSessionObserver)
        
        let viewController = viewControllerFactory.viewController(for: PresentableRoutingStep(withStep: .onboarding(switchPageEvent: switchTonextPageObserver),
                                                                                              presentationMode: .none))
        
        let rootNavigationController = UINavigationController(rootViewController: viewController)
        
        AppDelegate.shared.window?.transitionToRootController(rootNavigationController)
        topViewController = rootNavigationController
        
        return rootNavigationController
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
