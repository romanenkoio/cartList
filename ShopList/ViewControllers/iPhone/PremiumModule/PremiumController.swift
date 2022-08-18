//
//  PremiumController.swift
//  ShopList
//
//  Created by Illia Romanenko on 15.07.22.
//

import UIKit
import Lottie
import Adapty

class PremiumController: UIViewController {
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var infoCollection: UICollectionView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var monthSubButton: UIButton!
    @IBOutlet weak var yearSubButton: UIButton!
    @IBOutlet weak var foreverSubButton: UIButton!
    @IBOutlet weak var restorePurchasesButton: UIButton!
        
    private var paywall: PaywallModel?
    private var timer: Timer?
    private var counter = 0
    
    var infoArray = ["Неограниченное количество списков", "Отсутствие рекламы", "Возможность закреплять списки"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Adapty.getPaywalls { [weak self] paywals, productModel, error in
            if let error = error {
                self?.dismiss(animated: true)
                return
            }
            self?.paywall = paywals?.first
            self?.configureButtons()
        }
        updateLanguage()
        subscribeToNotification()
        setupCollection()
        pageController.hidesForSinglePage = true
        pageController.numberOfPages = infoArray.count
        setTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureButtons() {
        guard let paywal = paywall else {
            return
        }

        paywal.products.forEach { product in
            switch product.subscriptionPeriod?.unit {
            case .month:
                monthSubButton.setTitle("\(product.localizedPrice!) / \(AppLocalizationKeys.premiumMonth.localized())", for: .normal)
            case .year:
                yearSubButton.setTitle("\(product.localizedPrice!) / \(AppLocalizationKeys.premiumYear.localized())", for: .normal)
            case .none:
                foreverSubButton.setTitle("\(product.localizedPrice!) / \(AppLocalizationKeys.premiumLifetime.localized())", for: .normal)
            default: break
            }
        }
    }
    
    @IBAction func makePurchase(_ sender: UIButton) {
        var product: ProductModel?
        
        switch sender.tag {
        case 1000:
            product = paywall?.products.filter({ $0.subscriptionPeriod?.unit == .month }).first
        case 1001:
            product = paywall?.products.filter({ $0.subscriptionPeriod?.unit == .year }).first
        case 1002:
            product = paywall?.products.filter({ $0.subscriptionPeriod?.unit == .none }).first
        default: break
        }
        
        guard let product = product else {
            return
        }
        Adapty.logShowPaywall(paywall!)
        Adapty.makePurchase(product: product) { purchaserInfo, receipt, appleValidationResult, product, error in
            if error == nil {
                if purchaserInfo != nil {
                    DefaultsManager.isPremium = true
                }
            }
        }
    }
    
    @IBAction func restoreAction(_ sender: Any) {
        Adapty.restorePurchases { purchaserInfo, receipt, appleValidationResult, error in
            if purchaserInfo != nil {
                DefaultsManager.isPremium = true
            }
        }
    }
    
    private func setupCollection() {
        infoCollection.dataSource = self
        infoCollection.delegate = self
        infoCollection.register(UINib(nibName: String(describing: InfoCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: InfoCell.self))
    }
    
    func setTimer() {
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(updateCollection(sender:)), userInfo: nil, repeats: true)
    }
    
    @objc func updateCollection(sender: Timer) {
        if counter < infoArray.count - 1 {
            counter += 1
            let x = CGFloat(counter) * view.frame.width
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut]) {
                self.infoCollection.setContentOffset(CGPoint(x:x, y:0), animated: false)
                self.view.layoutIfNeeded()
            }
        } else {
            counter = 0
            let x = CGFloat(counter) * view.frame.width
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut]) {
                self.infoCollection.setContentOffset(CGPoint(x:x, y:0), animated: false)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func updateLanguage() {
        headerLabel.text = AppLocalizationKeys.premiumInfo.localized()
//        monthSubButton.setTitle(AppLocalizationKeys.premiumMonthSub.localized(), for: .normal)
//        yearSubButton.setTitle(AppLocalizationKeys.premiumyYearSub.localized(), for: .normal)
//        foreverSubButton.setTitle(AppLocalizationKeys.premiumyYearSub.localized(), for: .normal)
        restorePurchasesButton.setTitle(AppLocalizationKeys.restorePurchases.localized(), for: .normal)
//        infoArray = AppLocalizationKeys.premiumAdvantages.localized()
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .languageChange, object: nil)
    }

}

extension PremiumController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return infoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InfoCell.self), for: indexPath)
        guard let infoCell = cell as? InfoCell else { return cell }
        infoCell.infoLabel.text = infoArray[counter]
        return infoCell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageController.currentPage = indexPath.section
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
