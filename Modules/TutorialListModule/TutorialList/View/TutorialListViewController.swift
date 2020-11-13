//
//  TutorialListViewController.swift
//  TutorialListModule
//
//  Created by Vlad Z. on 2/16/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import HUIKit
import MERLin
import RxDataSources

class TutorialListViewController:
    UIViewController,
    UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    
    let viewModel: TutorialListViewModel
    private let actions = PublishSubject<TutorialListUIAction>()
    
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
        $0.register(ActionCardCell.self)
        $0.showsHorizontalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let skipButton = UIButton(type: .custom) <~ {
        $0.backgroundColor = .clear
        $0.setTitle("SKIP", for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, TutorialItem>>!
    
    init(with viewModel: TutorialListViewModel) {
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
    
    private func layout() {
        [titleLabel,
         descriptionLabel,
         collectionView,
         skipButton].forEach { view.addSubview($0) }
        
        titleLabel.sizeToFit()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 130),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 80),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -80)
        ])
        
        descriptionLabel.sizeToFit()
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                  constant: 25),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant: 80),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -80),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -30),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                                constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: 37),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                     constant: -37),
            collectionView.bottomAnchor.constraint(equalTo: skipButton.topAnchor,
                                                   constant: -25)
        ])
    }
    
    private func bindViewModel() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let states = viewModel.transform(input: actions).publish()
        states.capture(case: TutorialListState.items)
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
                case .discovery: self.actions.onNext(.actionTypeTapped(.discovery))
                case .navigation: self.actions.onNext(.actionTypeTapped(.navigation))
                }
            })
            .disposed(by: disposeBag)
        
        skipButton.rx.tap
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.actions.onNext(.actionTypeTapped(.skip))
            })
            .disposed(by: disposeBag)
        
        states.connect()
            .disposed(by: disposeBag)
    }
    
    private func configureDatasource() {
        titleLabel.text = "Enhance your weekend with the PGA TOUR."
        descriptionLabel.text = "Choose an option to find out more."
        
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
               height: (collectionView.frame.height / CGFloat(dataSource.sectionModels.count)) - 20)
    }
    
    private func applyTheme() {
        view.backgroundColor = .color(forPalette: .grey100)
        collectionView.backgroundColor = .color(forPalette: .grey100)
        
        navigationController?.navigationBar.isHidden = true
        
        titleLabel.applyLabelStyle(.headline(attribute: .bold))
        titleLabel.textColor = .color(forPalette: .black)
        
        descriptionLabel.applyLabelStyle(.title(attribute: .regular))
        descriptionLabel.textColor = .color(forPalette: .grey300)
        
        skipButton.setTitleColor(.color(forPalette: .grey300),
                                 for: .normal)
    }
}

extension TutorialListViewController {
    func configureCell(row: TutorialItem,
                       indexPath: IndexPath,
                       from collectionView: UICollectionView) -> UICollectionViewCell {
        let cell: ActionCardCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.titleLabel.text = row.title
        cell.iconImageView.image = row.iconImage
        cell.descriptionLabel.text = row.description
        cell.actionIconImageView.image = Asset.iconForward.image
        
        cell.applyTheme()
        
        return cell
    }
}

extension TutorialItem: IdentifiableType {
    public var identity: String { return title }
}
