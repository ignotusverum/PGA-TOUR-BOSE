//
//  NavigationTutorialViewController.swift
//  NavigationTutorialModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import HUIKit
import MERLin
import RxDataSources

import Lottie

private enum LocationAnimationFrames: Int, CaseIterable {
    case initial = 1
    case turnLeft
    case tapLeft
    case turnRight
    case tapRight
}

class NavigationTutorialViewController:
    UIViewController,
    UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    
    let viewModel: NavigationTutorialViewModel
    private let actions = PublishSubject<NavigationTutorialUIAction>()
    
    let pageControl = UIPageControl() <~ {
        $0.currentPage = 0
        $0.isUserInteractionEnabled = false
        $0.tintColor = .color(forPalette: .white)
        $0.pageIndicatorTintColor = .color(forPalette: .white)
        $0.currentPageIndicatorTintColor = .color(forPalette: .grey300)
    }
    
    let navigationTitleLabel = UILabel() <~ {
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let detailsLabel = UILabel() <~ {
        $0.numberOfLines = 3
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout()) <~ {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 60,
                                           bottom: 0,
                                           right: 60)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 120
        
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
        $0.collectionViewLayout = layout
        $0.register(CustomViewCell.self)
        $0.showsHorizontalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, NavigationTutorialPage>>!
    
    var pulseArray = [CAShapeLayer]()
    var headerImageRightConstraints: NSLayoutConstraint?
    
    init(with viewModel: NavigationTutorialViewModel) {
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
        navigationTitleLabel.text = "On-Course Navigation"
        
        navigationController?.navigationBar.isHidden = true
        
        [navigationTitleLabel,
         detailsLabel,
         collectionView,
         pageControl].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            navigationTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                      constant: 60),
            navigationTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationTitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: navigationTitleLabel.bottomAnchor,
                                              constant: 30),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -52),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: 52),
            detailsLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor,
                                                constant: 20),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                 constant: -20),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                  constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor,
                                                   constant: -40)
        ])
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.heightAnchor.constraint(equalToConstant: 60),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: -20)
        ])
    }
    
    private func applyTheme() {
        view.backgroundColor = .color(forPalette: .grey100)
        
        navigationController?.navigationBar.isHidden = true
        
        navigationTitleLabel.applyLabelStyle(.subtitle(attribute: .regular),
                                             customizing: { label, _ in
                                                 label.textColor = .color(forPalette: .grey300)
        })
        
        detailsLabel.applyLabelStyle(.navigationTitle(attribute: .bold))
    }
    
    private func bindViewModel() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] (_, indexPath) in
                guard let self = self else { return }
                self.pageControl.currentPage = indexPath.section
                
                let page = self.dataSource[indexPath]
                
                UIView.transition(with: self.detailsLabel,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                      self.detailsLabel.text = page.title
                }, completion: nil)
                
                self.actions.onNext(.changedToType(page.type))
            })
            .disposed(by: disposeBag)
        
        let states = viewModel.transform(input: actions).publish()
        states.capture(case: NavigationTutorialState.pages)
            .take(1)
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] pages in
                guard let self = self else { return }
                self.pageControl.numberOfPages = pages.count
            })
            .disposed(by: disposeBag)
        
        states.capture(case: NavigationTutorialState.pages)
            .take(1)
            .asDriverIgnoreError()
            .map { $0.map { AnimatableSectionModel(model: "",
                                                   items: [$0]) } }
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
                                   from: collectionView) }
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 120,
                      height: collectionView.frame.height)
    }
}

extension NavigationTutorialViewController {
    func configureCell(row: NavigationTutorialPage,
                       indexPath: IndexPath,
                       from collectionView: UICollectionView) -> UICollectionViewCell {
        let cell: CustomViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = dataSource[indexPath]
        switch item.type {
        case .player:
            let customView = UIImageView(image: Asset.iconPlayerList.image)
            cell.customView = customView
        case .frames:
            guard let path = Bundle(for: type(of: self)).path(forResource: "voiceover",
                                                              ofType: "json") else {
                break
            }
            
            let animationView = AnimationView.init(filePath: path)
            animationView.play()
            animationView.loopMode = .loop
            cell.customView = animationView
        case .direction(let titles):
            guard let path = Bundle(for: type(of: self)).path(forResource: "navigation",
                                                              ofType: "json") else {
                break
            }
            
            let animationView = AnimationView.init(filePath: path)
            animationView.play()
            animationView.loopMode = .loop
            animationView.animationSpeed = 0.9
            
            cell.customView = animationView
            
            /// Animation progress hack
            AnimationProgressObserver(animationView: animationView, onChange: { [weak self] currentFrame in
                guard let self = self,
                    self.pageControl.currentPage == 2 else { return }
                /// 190 - magical number from lottie that should handle context switches in animation with 90% speed
                let currentFramePage: Int = Int(currentFrame) / 190
                guard let currentCopy = titles[safe: currentFramePage] else { return }
                
                UIView.transition(with: self.detailsLabel,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                      self.detailsLabel.text = currentCopy
                }, completion: nil)
            })
        case .voice(let page):
            switch page {
            case 0:
                let customView = UIImageView(image: Asset.iconVoice1.image.withAlignmentRectInsets(UIEdgeInsets(top: -50, left: -50, bottom: -50, right: -50)))
                cell.customView = customView
            case 1:
                let customView = UIImageView(image: Asset.iconVoice2.image.withAlignmentRectInsets(UIEdgeInsets(top: -50, left: -50, bottom: -50, right: -50)))
                cell.customView = customView
            default: break
            }
        }
        
        return cell
    }
}

extension NavigationTutorialPage: IdentifiableType {
    public var identity: String { return title }
}

class AnimationProgressObserver {
    typealias ProgressChangeBlock = (_ progress: CGFloat) -> Void
    
    private weak var animationView: AnimationView?
    private var onChange: ProgressChangeBlock
    private var lastAnimationProgress: CGFloat = -1
    
    @discardableResult
    init(animationView: AnimationView,
         onChange: @escaping ProgressChangeBlock) {
        self.animationView = animationView
        self.onChange = onChange
        let displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick))
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc private func displayLinkTick() {
        guard let currentProgress = animationView?.realtimeAnimationFrame else {
            return
        }
        if lastAnimationProgress != currentProgress {
            lastAnimationProgress = currentProgress
            onChange(currentProgress)
        }
    }
}
