//
//  ReadoutSettingsView.swift
//  HFoundation
//
//  Created by Vlad Z. on 2/18/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HUIKit
import UIKit

import MERLin

public enum ReadoutSettingsDatasource: String, CaseIterable {
    case players = "Players on This Hole"
    case holeNumber = "Hole Number"
    case yardage = "Yardage"
    case par = "Par"
}

public class ReadoutSettingsView:
    UIView,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    let datasource = ReadoutSettingsDatasource.allCases
    
    public let titleLabel = PaddingLabel() <~ {
        $0.leftInset = 25
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public let collectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: UICollectionViewFlowLayout()) <~ {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        $0.collectionViewLayout = layout
        $0.register(TitleToggleCell.self)
        $0.showsHorizontalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        titleLabel.text = "Readout Settings"
        
        layout()
        applyTheme()
        bind()
    }
    
    private func layout() {
        [titleLabel,
         collectionView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 70),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                constant: 2),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func bind() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let readoutObserver = GlobalConfig.readoutObservable
        readoutObserver
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TitleToggleCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = datasource[indexPath.section]
        
        let config = GlobalConfig.readout
        cell.titleLabel.text = item.rawValue.capitalized
        
        switch item {
        case .par: cell.toggle.isOn = config.par
        case .yardage: cell.toggle.isOn = config.yardage
        case .players: cell.toggle.isOn = config.players
        case .holeNumber: cell.toggle.isOn = config.holeNumber
        }
        
        cell.applyTheme()
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width,
               height: 60)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        datasource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        1
    }
}
