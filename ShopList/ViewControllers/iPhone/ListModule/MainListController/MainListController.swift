//
//  MainListController.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit
import Lottie
import GoogleMobileAds
import Firebase

class MainListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var createListButton: UIButton!
    var bannerView: GADBannerView!
    var database: DatabaseReference!
    
    var lists = [SLFirebaseList]() {
        didSet {
            tableView.reloadData()
           
            animationView.isHidden = lists.count != 0
            emptyLabel.isHidden = lists.count != 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellsWith([MainListCell.self])
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        updateLanguage()
        subscribeToNotification()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-4489210776569699/3621152755"
        emptyLabel.isHidden = true
        
        #if RELEASE
        if DefaultsManager.lainchCount % 2 == 0 {
            let vc = PremiumController.loadFromNib()
            self.present(vc, animated: true)
        }
        #endif
    }
    
    
    private func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: createListButton,
                                attribute: .top,
                                multiplier: 1,
                                constant: -10),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if DEBUG
        print("Реклама отключена")
        #else
        bannerView.load(GADRequest())
        #endif
        NotificationCenter.default.addObserver(self, selector: #selector(readLists), name: .listWasImported, object: nil)
        readLists()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func readLists() {
        SLFirManager.loadLists { [weak self] lists in
            self?.lists = lists
            self?.playAnimation()
        }
    }
    
    private func playAnimation() {
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.animation = Animation.named("cartAnimation")
        lists.count > 0 ? animationView.stop() : animationView.play()
        animationView.isHidden = lists.count != 0
        emptyLabel.isHidden = lists.count != 0
    }
    
    @IBAction func addListAction(_ sender: Any) {
        let vc = AddListController.loadFromNib()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.type = .list
        vc.saveAction = { [weak self] in
            guard let self = self else { return }
            
            self.readLists()
            self.dismiss(animated: true)
        }
        self.present(vc, animated: true)
    }
    
    private func shareList(list: SLFirebaseList) {
        SLShareManager.shareList(list, from: self)
    }
    
    @objc  func updateLanguage() {
        emptyLabel.text = AppLocalizationKeys.checkTheLists.localized()
        createListButton.setTitle(AppLocalizationKeys.createList.localized(), for: .normal)
        title = AppLocalizationKeys.myLists.localized()
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .languageChange, object: nil)
    }
}

extension MainListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainListCell.self), for: indexPath) as! MainListCell
        let list = lists[indexPath.row]
        listCell.pinImage.isHidden = !list.isPinned
        listCell.listNameLabel.text = list.listName
        listCell.cellView.backgroundColor = list.isPinned ? .mainOrange.withAlphaComponent(0.1) : .white
        listCell.cellView.layer.borderColor = UIColor.mainOrange.cgColor
        return listCell
    }
}

extension MainListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductList.loadFromNib()
        vc.currentList = lists[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {  [weak self] _ in
            guard let self = self else { return nil }
            
            let pin = UIAction(title: AppLocalizationKeys.pin.localized(), image: UIImage(systemName: "pin")) { [weak self] _ in
                guard let self = self else { return }
                self.lists[indexPath.row].isPinned = true
                SLFirManager.updateList(self.lists[indexPath.row])
                self.readLists()
            }
            
            let unPin = UIAction(title: AppLocalizationKeys.unpin.localized(), image: UIImage(systemName: "pin.slash")) { [weak self] _ in
                guard let self = self else { return }
                self.lists[indexPath.row].isPinned = false
                SLFirManager.updateList(self.lists[indexPath.row])
                self.readLists()
            }
            
            let share = UIAction(title: AppLocalizationKeys.alertShare.localized(), image: UIImage(systemName: "arrowshape.turn.up.right")) { [weak self] _ in
                guard let self = self else { return }
                self.shareList(list: self.lists[indexPath.row])
            }
            
            let delete = UIAction(title: AppLocalizationKeys.delete.localized(), image: UIImage(systemName: "trash"), attributes: UIMenuElement.Attributes.destructive) { _ in
                let alert = UIAlertController(title: AppLocalizationKeys.confirm.localized(), message: AppLocalizationKeys.deleteEntry.localized(), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: AppLocalizationKeys.delete.localized(), style: .destructive, handler: { _ in
                    SLFirManager.removeList(self.lists[indexPath.row]) { success in
                        if success {
                            self.readLists()
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .default))
                
                self.present(alert, animated: true)
            }
            
            if self.lists[indexPath.row].isPinned {
                return UIMenu(title: "", children: [unPin, share, delete])
            } else if !self.lists[indexPath.row].isPinned, self.lists.filter({ $0.isPinned }).count < 3 {
                return UIMenu(title: "", children: [pin, share, delete])
            }
            return UIMenu(title: "", children: [share, delete])
        }
        return configuration
    }
}

extension MainListController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        addBannerViewToView(bannerView)
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
