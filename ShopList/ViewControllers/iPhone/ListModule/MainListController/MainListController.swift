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
    var query: DatabaseQuery?
    
    private weak var timer: Timer?
    
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
        
        SLFirManager.getUser()
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
    
    private func scheduledTimer() {
        timer = nil
        DispatchQueue.global().async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.readLists()
                }
            })

            RunLoop.current.run()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        timer = nil
        query?.removeAllObservers()
    }
    
    @objc private func readLists() {
        self.query = SLFirManager.loadLists { [weak self] lists in
            let pinnedLists = lists.filter({ DefaultsManager.pinnedLists.contains($0.id!)}).sorted(by: { $0.listName! > $1.listName! })
            let clearLists = lists.filter({ !DefaultsManager.pinnedLists.contains($0.id!)}).sorted(by: { $0.listName! > $1.listName! })
            self?.lists = pinnedLists + clearLists
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
        listCell.setupWith(list)

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
            
            let listPinned = DefaultsManager.pinnedLists.contains(self.lists[indexPath.row].id!)
            let pin = UIAction(title: listPinned ? AppLocalizationKeys.unpin.localized() : AppLocalizationKeys.pin.localized(), image: UIImage(systemName: listPinned ? "pin.slash" : "pin")) { [weak self] _ in
                guard let self = self else { return }
                
                self.lists[indexPath.row].isPinned = !listPinned
                if listPinned {
                    guard let index = DefaultsManager.pinnedLists.firstIndex(of: self.lists[indexPath.row].id!) else { return }
                    DefaultsManager.pinnedLists.remove(at: index)
                } else {
                    DefaultsManager.pinnedLists.append(self.lists[indexPath.row].id!)
                }

                tableView.reloadData()
            }
            
            let shareToProfile = UIAction(title: "Добавить пользователя", image: UIImage(systemName: "person.circle")) { [weak self] _ in
                guard let self = self else { return }
                let vc = SearchUserController.loadFromNib()
                vc.selectionBlock = { user in
                    SLFirManager.shareListByEmail(self.lists[indexPath.row], for: user.uid!)
                }
                self.present(vc, animated: true)
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
                            if let index = DefaultsManager.pinnedLists.firstIndex(of: self.lists[indexPath.row].id!) {
                                DefaultsManager.pinnedLists.remove(at: index)

                            }
                            self.readLists()
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .default))
                
                self.present(alert, animated: true)
            }
            
            if self.lists[indexPath.row].isPinned {
                return UIMenu(title: "", children: [pin, share, shareToProfile, delete])
            } else if !self.lists[indexPath.row].isPinned, self.lists.filter({ $0.isPinned }).count < 3 {
                return UIMenu(title: "", children: [pin, share, shareToProfile, delete])
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
