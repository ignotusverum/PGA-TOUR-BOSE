//
//  OnboardingViewController.swift
//  OnboardingModule
//
//  Created by Vlad Z. on 2/11/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import HFoundation
import HUIKit
import MERLin
import RxDataSources

class OnboardingViewController:
    UIViewController,
    UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    
    let viewModel: OnboardingViewModel
    let switchPageEvent: Observable<Void>
    
    private let actions = PublishSubject<OnboardingUIAction>()
    
    let pageControl = UIPageControl() <~ {
        $0.currentPage = 0
        $0.isUserInteractionEnabled = false
        $0.tintColor = .color(forPalette: .grey300)
        $0.pageIndicatorTintColor = .color(forPalette: .grey300)
        $0.currentPageIndicatorTintColor = .color(forPalette: .white)
    }
    
    let headerImage = UIImageView() <~ {
        $0.contentMode = .scaleAspectFit
        $0.image = Asset.iconGlasses.image
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout()) <~ {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 120
        
        $0.isPagingEnabled = true
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.collectionViewLayout = layout
        $0.register(TitleActionCell.self)
        $0.showsHorizontalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, OnboardingPage>>!
    
    var pulseArray = [CAShapeLayer]()
    var headerImageRightConstraints: NSLayoutConstraint?
    
    init(with viewModel: OnboardingViewModel,
         switchPageEvent: Observable<Void>) {
        self.viewModel = viewModel
        self.switchPageEvent = switchPageEvent
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
    }
    
    private func layout() {
        view.setBackgroundImage(Asset.gradientBackground.image)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        [headerImage,
         collectionView,
         pageControl].forEach { view.addSubview($0) }
        
        headerImageRightConstraints = headerImage.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                                         constant: 15)
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                             constant: 130),
            headerImage.widthAnchor.constraint(equalTo: view.widthAnchor,
                                               multiplier: 0.85),
            headerImage.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                multiplier: 0.25),
            headerImageRightConstraints!
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerImage.bottomAnchor,
                                                constant: 65),
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
    
    private func bindViewModel() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] (_, indexPath) in
                guard let self = self else { return }
                self.pageControl.currentPage = indexPath.section
                
                let page = self.dataSource[indexPath]
                self.actions.onNext(.changedToType(page.type))
                
                if indexPath.section == self.dataSource.sectionModels.count - 1 {
                    self.triggerAnimation()
                }
            })
            .disposed(by: disposeBag)
        
        let states = viewModel.transform(input: actions).publish()
        states.capture(case: OnboardingState.pages)
            .take(1)
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] pages in
                guard let self = self else { return }
                self.pageControl.numberOfPages = pages.count
            })
            .disposed(by: disposeBag)
        
        switchPageEvent
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.scrollToNextItem()
            })
            .disposed(by: disposeBag)
        
        states.capture(case: OnboardingState.pages)
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
                                   from: collectionView)
            }
        )
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
        
        cell.actionButton.setImage(row.buttonDatasource.image,
                                   for: .normal)
        cell.actionButton.setTitle(row.buttonDatasource.title,
                                   for: .normal)
        
        cell.descriptionLabel.text = row.details
        cell.applyTheme()
        
        cell.actionButton.rx.tap
            .takeUntil(cell.rx.sentMessage(#selector(cell.prepareForReuse)))
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.actions.onNext(.actionTypeTapped(row.type))
            })
            .disposed(by: disposeBag)
        
        return cell
    }
}

extension OnboardingPage: IdentifiableType {
    public var identity: String { return title }
}

extension OnboardingViewController {
    private func triggerAnimation() {
        headerImage.image = Asset.iconCheckmark.image
        
        headerImageRightConstraints?.isActive = false
        
        NSLayoutConstraint.activate([
            headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        UIView.animate(withDuration: 0.2) {
            self.headerImage.layoutIfNeeded()
        }
        
        createPulse()
    }
    
    private func createPulse() {
        for _ in 0 ... 2 {
            let circularPath = UIBezierPath(arcCenter: .zero,
                                            radius: ((headerImage.superview?.frame.size.width)!) / 2,
                                            startAngle: 0,
                                            endAngle: 2 * .pi,
                                            clockwise: true)
            let pulsatingLayer = CAShapeLayer()
            pulsatingLayer.path = circularPath.cgPath
            pulsatingLayer.lineWidth = 2.5
            pulsatingLayer.fillColor = UIColor.clear.cgColor
            pulsatingLayer.lineCap = .round
            pulsatingLayer.position = CGPoint(x: headerImage.center.x - 45,
                                              y: headerImage.center.y)
            view.layer.insertSublayer(pulsatingLayer, below: headerImage.layer)
            pulseArray.append(pulsatingLayer)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.animatePulsatingLayerAt(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.animatePulsatingLayerAt(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.animatePulsatingLayerAt(index: 2)
                })
            })
        })
    }
    
    private func animatePulsatingLayerAt(index: Int) {
        pulseArray[index].strokeColor = UIColor.color(forPalette: .white).cgColor
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        groupAnimation.duration = 2.3
        groupAnimation.repeatCount = .greatestFiniteMagnitude
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        pulseArray[index].add(groupAnimation, forKey: "groupanimation")
    }
}
