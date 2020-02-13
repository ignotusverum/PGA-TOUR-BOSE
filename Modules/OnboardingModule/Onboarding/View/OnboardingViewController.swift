//
//  OnboardingViewController.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

import HUIKit
import HFoundation
import RxDataSources

class OnboardingViewController:
    UIViewController,
UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    
    let viewModel: OnboardingViewModel
    private let actions = PublishSubject<OnboardingUIAction>()
    
    private let headerImage = UIImageView() <~ {
        $0.contentMode = .scaleAspectFit
        $0.image = Asset.iconGlasses.image
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout()) <~ {
                                                    let layout = UICollectionViewFlowLayout()
                                                    
                                                    layout.sectionInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
                                                    layout.scrollDirection = .horizontal
                                                    layout.minimumLineSpacing = 120
                                                    
                                                    $0.isPagingEnabled = true
                                                    $0.backgroundColor = .clear
                                                    $0.collectionViewLayout = layout
                                                    $0.register(TitleActionCell.self)
                                                    $0.showsHorizontalScrollIndicator = false
                                                    $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, OnboardingPage>>!
    
    init(with viewModel: OnboardingViewModel) {
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
        collectionView.reloadData()
        
        configureDatasource()
        bindViewModel()
    }
    
    private func layout() {
        setBackgroundImage(Asset.gradientBackground.image)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        [headerImage,
         collectionView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                             constant: 130),
            headerImage.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                multiplier: 0.25),
            headerImage.widthAnchor.constraint(equalTo: view.widthAnchor,
                                               multiplier: 0.85),
            headerImage.rightAnchor.constraint(equalTo: view.rightAnchor,
                                               constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerImage.bottomAnchor,
                                                constant: 65),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                 constant: -20),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                  constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                   constant: -100)
        ])
    }
    
    private func bindViewModel() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let states = viewModel.transform(input: actions).publish()
        states.capture(case: OnboardingState.pages)
            .take(1)
            .asDriverIgnoreError()
            .map { $0.map { AnimatableSectionModel(model: "",
                                                   items: [$0])}}
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        states.connect()
            .disposed(by: disposeBag)
    }
    
    private func configureDatasource() {
        dataSource = RxCollectionViewSectionedAnimatedDataSource(
            configureCell: { (_, collectionView, indexPath, row) -> UICollectionViewCell in
                self.configureCell(row: row,
                                   indexPath: indexPath,
                                   from: collectionView)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 120,
                      height: collectionView.frame.height)
    }
}

extension OnboardingViewController {
    func configureCell(row: OnboardingPage,
                       indexPath: IndexPath,
                       from collectionView: UICollectionView) -> UICollectionViewCell {
        let cell: TitleActionCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.titleLabel.text = row.title
        cell.actionButton.setTitle(row.buttonDatasource.title, for: .normal)
        
        cell.descriptionLabel.text = row.details
        
        cell.applyTheme()
        return cell
    }
}


extension OnboardingPage: IdentifiableType {
    public var identity: String { return title }
}
