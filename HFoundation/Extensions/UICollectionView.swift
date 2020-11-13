//
//  UICollectionView.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/12/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass,
                 forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath,
                                                      and reuseIdentifier: String = String(describing: T.self)) -> T {
        dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                            for: indexPath) as! T
    }
    
    func registerNib<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let nib = UINib(nibName: "\(T.self)",
            bundle: Bundle(for: T.self))
        register(nib,
                 forCellWithReuseIdentifier: "\(cellClass.self)")
    }
    
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}

