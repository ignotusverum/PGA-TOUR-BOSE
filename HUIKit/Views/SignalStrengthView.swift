//
//  SignalStrengthView.swift
//  HUIKit
//
//  Created by Vlad Z. on 2/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

public class SignalStrengthView: UIView {
    public enum SignalStrengthType: Int {
        case noSignal = 0
        case low
        case good
        case excellent
    }
    
    public var level: SignalStrengthType {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var spacing: CGFloat = 2
    public var color = UIColor.white
    public var edgeInsets = UIEdgeInsets(top: 3,
                                         left: 3,
                                         bottom: 3,
                                         right: 3)
    
    public init(level: SignalStrengthType) {
        self.level = level
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setNeedsDisplay()
    }
    
    private let indicatorsCount: Int = 4
    public override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ctx.saveGState()
        
        let levelValue = level.rawValue
        
        let barsCount = CGFloat(indicatorsCount)
        let barWidth = (rect.width - edgeInsets.right - edgeInsets.left - ((barsCount - 1) * spacing)) / barsCount
        let barHeight = rect.height - edgeInsets.top - edgeInsets.bottom
        
        for index in 0 ... indicatorsCount - 1 {
            let i = CGFloat(index)
            let width = barWidth
            let height = barHeight - (((barHeight * 0.5) / barsCount) * (barsCount - i))
            let x: CGFloat = edgeInsets.left + i * barWidth + i * spacing
            let y: CGFloat = barHeight - height
            let cornerRadius: CGFloat = barWidth * 0.25
            let barRect = CGRect(x: x, y: y, width: width, height: height)
            let clipPath: CGPath = UIBezierPath(roundedRect: barRect, cornerRadius: cornerRadius).cgPath
            
            ctx.addPath(clipPath)
            ctx.setFillColor(color.cgColor)
            ctx.setStrokeColor(color.cgColor)
            
            if index + 1 > levelValue {
                ctx.strokePath()
            } else {
                ctx.fillPath()
            }
        }
        
        ctx.restoreGState()
    }
}
