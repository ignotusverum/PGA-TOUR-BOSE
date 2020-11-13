//
//  PlayersViewController.swift
//  Huge-PGA
//
//  Created by Jean Victor on 3/3/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import HUIKit
import MERLin
import RxDataSources

extension Player: Equatable, IdentifiableType, Comparable {
    public var identity: String { return id }
    
    public static func == (lhs: Player, rhs: Player) -> Bool { lhs.id == rhs.id }
    
    public static func < (lhs: Player, rhs: Player) -> Bool {
        return rhs.lfFull > lhs.lfFull
    }
}

class PlayerListViewController:
    UIViewController,
    UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    
    let viewModel: PlayerListViewModel
    private let actions = PublishSubject<PlayerListUIAction>()
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout()) <~ {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        $0.allowsSelection = false
        $0.collectionViewLayout = layout
        $0.register(PlayerSelectionCell.self)
        $0.register(PlayerSingleSelectionCell.self)
        $0.register(HeaderSelectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlayerViewHdr")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    let refreshControl = UIRefreshControl() <~ {
        $0.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Player>>!
    
    init(with viewModel: PlayerListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()
        configureDatasource()
        bindViewModel()
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(collectionView)
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        collectionView.addSubview(refreshControl)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            (navigationController?.navigationBar.heightAnchor.constraint(equalToConstant: 100))!
        ])
    }
    
    private func bindViewModel() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.actions.onNext(.reload)
            })
            .disposed(by: disposeBag)
        
        let states = viewModel.transform(input: actions).publish()
        
        states.capture(case: PlayerListState.players)
            .asDriverIgnoreError()
            .map { [AnimatableSectionModel(model: "", items: $0)] }
            .do(onNext: { [weak self] rows in
                self?.refreshControl.endRefreshing()
            })
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        states.capture(case: PlayerListState.error)
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] (error, _) in
                guard let self = self else { return }
                
                let alert = UIAlertController(title: "Whoops",
                                              message: "Something went wrong, please try again.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Reload",
                                              style: UIAlertAction.Style.default,
                                              handler: { _ in
                                                  self.actions.onNext(.reload)
                }))
                
                self.present(alert,
                             animated: true,
                             completion: nil)
            })
            .disposed(by: disposeBag)
        
        states.capture(case: PlayerListState.loading)
            .toVoid()
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] in
                self?.activityIndicator.startAnimating()
            }).disposed(by: disposeBag)
        
        states.exclude(case: PlayerListState.loading)
            .toVoid()
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] in
                self?.activityIndicator.stopAnimating()
            }).disposed(by: disposeBag)
        
        states.connect()
            .disposed(by: disposeBag)
    }
    
    private func configureDatasource() {
        dataSource = RxCollectionViewSectionedAnimatedDataSource(
            configureCell: { (dataSource, collectionView, indexPath, row) -> UICollectionViewCell in
                self.configureCell(player: row,
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
               height: 70)
    }
    
    private func applyTheme() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
        
        view.setBackgroundImage(Asset.gradientBackground.image)
        collectionView.backgroundColor = .clear
    }
}

extension PlayerListViewController {
    func configureCell(player: Player,
                       indexPath: IndexPath,
                       from collectionView: UICollectionView) -> UICollectionViewCell {
        switch player.nextHole {
        case let hole where hole != -1:
            let cell: PlayerSelectionCell = collectionView.dequeueReusableCell(for: indexPath)
            
            cell.nameLabel.text = player.flName
            cell.applyTheme()
            
            cell.currentHoleLabel.text = "Hole \(player.currentHole)"
            cell.teeButton.setTitle("Hole \(player.nextHole)", for: .normal)
            cell.teeButton.rx.tap.subscribe(onNext: { [weak self] _ in
                self?.actions.onNext(.playerSelected(player.nextHole, "tee"))
            }).disposed(by: disposeBag)
            cell.teeLabel.text = "Tee Box"
            
            cell.greenButton.setTitle("Hole \(player.nextHole)", for: .normal)
            cell.greenButton.rx.tap.subscribe(onNext: { [weak self] _ in
                self?.actions.onNext(.playerSelected(player.nextHole, "green"))
            }).disposed(by: disposeBag)
            cell.greenLabel.text = "Green"
            
            return cell
        default:
            let cell: PlayerSingleSelectionCell = collectionView.dequeueReusableCell(for: indexPath)
            
            cell.nameLabel.text = player.flName
            cell.detailsLabel.text = "F"
            
            cell.applyTheme()
            
            return cell
        }
    }
    
    func configureHeader(indexPath: IndexPath,
                         from collectionView: UICollectionView) -> UICollectionReusableView {
        let cell: HeaderSelectionCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlayerViewHdr", for: indexPath) as! HeaderSelectionCell
        
        cell.nameLabel.text = "Player / Location"
        cell.locationLabel.text = "Meet Them"
        cell.applyTheme()
        
        return cell
    }
}
