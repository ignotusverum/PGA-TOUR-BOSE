//
//  BannerViewTypes.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import UIKit

public final class InfoBannerView:
    UIView,
    BannerViewProtocol {
    public let title: String
    public let type: BannerType = .info
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = title
        label.textAlignment = .left
        return label
    }()
    
    public var rightView: UIView = SignalStrengthView(level: .good)
    public var leftView: UIView = UIImageView(image: Asset.iconBluetooth.image)
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public final class NotConnectedBannerView:
    UIView,
    BannerViewProtocol {
    public let title: String
    public let type: BannerType = .notConnected
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = title
        label.textAlignment = .left
        return label
    }()
    
    public var rightView: UIView = SignalStrengthView(level: .noSignal)
    public var leftView: UIView = UIImageView(image: Asset.iconBluetooth.image)
    
    public var onTap: (() -> Void)?
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        layout()
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(onTapAction))
        
        addGestureRecognizer(gesture)
    }
    
    @objc
    func onTapAction(sender: UITapGestureRecognizer) {
        onTap?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
