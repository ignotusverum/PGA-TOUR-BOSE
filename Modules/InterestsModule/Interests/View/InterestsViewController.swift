//
//  InterestsViewController.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/8/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import HUIKit
import MERLin
import RxDataSources

extension Interest: Equatable, IdentifiableType, Comparable {
    public var identity: Int { return id }
    
    public static func == (lhs: Interest, rhs: Interest) -> Bool { lhs.id == rhs.id }
    
    public static func < (lhs: Interest, rhs: Interest) -> Bool {
        return rhs.id < lhs.id
    }
}

class InterestsViewController:
    UIViewController,
    UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    
    let viewModel: InterestsViewModel
    private let actions = PublishSubject<InterestsUIAction>()
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout()) <~ {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 8,
                                           left: 0,
                                           bottom: 8,
                                           right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        $0.allowsSelection = false
        $0.backgroundColor = .gray
        $0.collectionViewLayout = layout
        $0.register(HoleSelectionCell.self)
        $0.register(HeaderSelectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InterestViewHdr")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, Interest>>!
    
    init(with viewModel: InterestsViewModel) {
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
        [collectionView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let states = viewModel.transform(input: actions).publish()
        states.capture(case: InterestsState.interests)
            .asDriverIgnoreError()
            .map {
                [SectionModel(model: "", items: $0)]
            }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        states.connect()
            .disposed(by: disposeBag)
    }
    
    private func configureDatasource() {
        dataSource = RxCollectionViewSectionedReloadDataSource(
            configureCell: { (dataSource, collectionView, indexPath, row) -> UICollectionViewCell in
                self.configureCell(interest: row,
                                   indexPath: indexPath,
                                   from: collectionView) },
            configureSupplementaryView: { (_, collectionView, _, indexPath) -> UICollectionReusableView in
                self.configureHeader(indexPath: indexPath,
                                     from: collectionView) }
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width,
               height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width,
               height: 50)
    }
    
    private func applyTheme() {
        view.setBackgroundImage(Asset.gradientBackground.image)
        
        collectionView.backgroundColor = .clear
        navigationController?.navigationBar.isHidden = false
    }
}

extension InterestsViewController {
    func configureCell(interest: Interest,
                       indexPath: IndexPath,
                       from collectionView: UICollectionView) -> UICollectionViewCell {
        let cell: HoleSelectionCell = collectionView.dequeueReusableCell(for: indexPath)
        
        switch interest.info {
        case .none:
            cell.teeButton.isHidden = true
            cell.dividerView.isHidden = true
            cell.greenButton.setTitle("Entrance", for: .normal)
            cell.greenButton.rx.tap.subscribe(onNext: { [weak self] _ in
                self?.actions.onNext(.interestSelected(interest.startCoords.lat, interest.startCoords.lng,
                                                       "\(interest.name)"))
            }).disposed(by: disposeBag)
        default:
            cell.teeButton.setTitle("Tee Box", for: .normal)
            cell.teeButton.rx.tap.subscribe(onNext: { [weak self] _ in
                self?.actions.onNext(.interestSelected(interest.startCoords.lat, interest.startCoords.lng, "\(interest.info!.formattedHoleNumber) tee"))
            }).disposed(by: disposeBag)
            
            cell.greenButton.setTitle("Green", for: .normal)
            cell.greenButton.rx.tap.subscribe(onNext: { [weak self] _ in
                self?.actions.onNext(.interestSelected(interest.startCoords.lat, interest.startCoords.lng,
                                                       "\(interest.info!.formattedHoleNumber) green"))
            }).disposed(by: disposeBag)
        }
        
        cell.nameLabel.text = interest.name
        cell.applyTheme()
        
        return cell
    }
    
    func configureHeader(indexPath: IndexPath,
                         from collectionView: UICollectionView) -> UICollectionReusableView {
        let cell: HeaderSelectionCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InterestViewHdr", for: indexPath) as! HeaderSelectionCell
        
        cell.nameLabel.text = "Location"
        cell.applyTheme()
        
        return cell
    }
}
