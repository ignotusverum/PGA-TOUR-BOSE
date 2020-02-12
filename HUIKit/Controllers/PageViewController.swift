//
//  PageViewController.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

open class PageViewController: UIPageViewController {
    private var items: [UIViewController]
    
    public init(items: [UIViewController]) {
        self.items = items
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: [:])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        configure(with: items)
    }
    
    public func configure(with items: [UIViewController]) {
        self.items = items
        
        decoratePageControl()
        if let firstViewController = items.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    private func decoratePageControl() {
        let pc = PageControl.appearance(whenContainedInInstancesOf: [PageViewController.self])
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .clear
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    public func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return items.last
        }
        
        return items[previousIndex]
    }
    
    public func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return items.first
        }
        
        return items[nextIndex]
    }
    
    public func presentationCount(for _: UIPageViewController) -> Int {
        return items.count
    }
    
    public func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}

