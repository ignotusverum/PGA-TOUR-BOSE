//
//  HomeViewController.swift
//  HomeModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import HUIKit
import MERLin
import RxDataSources

class HomeViewController:
    UIViewController,
    UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    
    let viewModel: HomeViewModel
    private let actions = PublishSubject<HomeUIAction>()
    
    let titleIconImageView = UIImageView() <~ {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let titleLabel = UILabel() <~ {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let descriptionLabel = UILabel() <~ {
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout()) <~ {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 8,
                                           left: 0,
                                           bottom: 8,
                                           right: 0)
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.collectionViewLayout = layout
        $0.register(IconTitleCell.self)
        $0.showsHorizontalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let readoutSettingsView = ReadoutSettingsView() <~ {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, HomeItem>>!
    
    init(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        configureDatasource()
        bindViewModel()
        applyTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func layout() {
        [titleIconImageView,
         titleLabel,
         descriptionLabel,
         collectionView,
         readoutSettingsView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            titleIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                    constant: 80),
            titleIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleIconImageView.heightAnchor.constraint(equalToConstant: 75),
            titleIconImageView.widthAnchor.constraint(equalToConstant: 55)
        ])
        
        titleLabel.sizeToFit()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleIconImageView.bottomAnchor,
                                            constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 80),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -80)
        ])
        
        descriptionLabel.sizeToFit()
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                  constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant: 80),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -80),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            readoutSettingsView.topAnchor.constraint(equalTo: collectionView.bottomAnchor,
                                                     constant: 25),
            readoutSettingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: 25),
            readoutSettingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                          constant: -25),
            readoutSettingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                        constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                                constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: 37),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                     constant: -37),
            collectionView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func bindViewModel() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let states = viewModel.transform(input: actions).publish()
        states.capture(case: HomeState.items)
            .take(1)
            .asDriverIgnoreError()
            .map { $0.map { AnimatableSectionModel(model: "",
                                                   items: [$0]) } }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let item = self.dataSource[indexPath]
                switch item.type {
                case .players: self.actions.onNext(.findPlayerTapped)
                case .pointsOfInterest: self.actions.onNext(.pointsOfInterestsTapped)
                }
            })
            .disposed(by: disposeBag)
        
        states.connect()
            .disposed(by: disposeBag)
    }
    
    private func configureDatasource() {
        titleIconImageView.image = Asset.iconPga.image
        titleLabel.text = "2020 Wells Fargo Championship"
        descriptionLabel.text = "Enhanced with Bose AR"
        
        dataSource = RxCollectionViewSectionedAnimatedDataSource(
            configureCell: { (_, collectionView, indexPath, row) -> UICollectionViewCell in
                self.configureCell(row: row,
                                   indexPath: indexPath,
                                   from: collectionView) }
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width,
               height: 65)
    }
    
    private func applyTheme() {
        view.setBackgroundImage(Asset.gradientBackground.image)
        collectionView.backgroundColor = .clear
        
        titleLabel.applyLabelStyle(.subtitle(attribute: .bold))
        titleLabel.textColor = .color(forPalette: .white)
        
        descriptionLabel.applyLabelStyle(.small(attribute: .regular))
        descriptionLabel.textColor = .color(forPalette: .grey300)
    }
}

extension HomeViewController {
    func configureCell(row: HomeItem,
                       indexPath: IndexPath,
                       from collectionView: UICollectionView) -> UICollectionViewCell {
        let cell: IconTitleCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.titleLabel.text = row.title
        cell.leftImageView.image = row.image
        cell.rightImageView.image = Asset.iconForward.image
        
        cell.applyTheme()
        
        return cell
    }
}

extension HomeItem: IdentifiableType {
    public var identity: String { return title }
}
