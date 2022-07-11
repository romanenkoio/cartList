//
//  MainListController.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit
import Lottie
import EasyTipView

class MainListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var createListButton: UIButton!
    
    var tipViews = [EasyTipView]()
    private var lists = [SLRealmList]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellsWith([MainListCell.self])
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        updateLanguage()
        subscribeToNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readData()
        playAnimation()
        showTips()
        
        NotificationCenter.default.addObserver(self, selector: #selector(readData), name: .listWasImported, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for view in tipViews {
            view.removeFromSuperview()
        }
    }
    
    @objc private func readData() {
        lists = RealmManager.read(type: SLRealmList.self).filter({ $0.isPinned})
        lists += RealmManager.read(type: SLRealmList.self).filter({ !$0.isPinned})
        playAnimation()
    }
    
    private func showTips() {
        if DefaultsManager.isFirstListLaunch, lists.count > 0 {
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
                guard let self = self else { return }

                let tipView = EasyTipView(text: AppLocalizationKeys.pinchList.localized(),
                                          preferences: EasyTipView.globalPreferences,
                                          delegate: nil)
                guard let firstCell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) else { return }
                tipView.show(forView: firstCell)
                self.tipViews.append(tipView)
                DefaultsManager.isFirstListLaunch = false
            }
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
            
            self.readData()
            self.dismiss(animated: true)
            let vc = ProductList.loadFromNib()
            vc.list = self.lists.last
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.present(vc, animated: true)
    }
    
    private func shareList(list: SLRealmList) {
        let alert = Alerts.share.controller
        
        let asText = UIAlertAction(title: AppLocalizationKeys.text.localized(), style: .default) { [weak self] _ in
            var text = "\(AppLocalizationKeys.seeMyList.localized()) \(list.listName)\n\n"
            
            let products = RealmManager.read(type: SLRealmProduct.self).filter({ $0.ownerListID == list.id})
            for product in products {
                text += "\(product.productName), \(product.productCount) \(product.produckPkg)\n"
            }
            
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self?.view
            
            self?.present(activityViewController, animated: true, completion: nil)
        }
        
        let asFile = UIAlertAction(title: AppLocalizationKeys.file.localized(), style: .default) { [weak self] _ in
            guard let self = self else { return }
            SLShareManager.shareList(list, from: self)
        }
        
        let cancel = UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .cancel)
        
        alert.addAction(asText)
        alert.addAction(asFile)
        alert.addAction(cancel)
        self.present(alert, animated: true)
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
        listCell.setupWith(lists[indexPath.row])
        return listCell
    }
}

extension MainListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductList.loadFromNib()
        vc.list = lists[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {  [weak self] _ in
            guard let self = self else { return nil }
            
            let pin = UIAction(title: AppLocalizationKeys.pin.localized(), image: UIImage(systemName: "pin")) { [weak self] _ in
                guard let self = self else { return }
                RealmManager.beginWrite()
                self.lists[indexPath.row].isPinned = true
                RealmManager.commitWrite()
                self.readData()
            }
            
            let unPin = UIAction(title: AppLocalizationKeys.unpin.localized(), image: UIImage(systemName: "pin.slash")) { [weak self] _ in
                guard let self = self else { return }
                RealmManager.beginWrite()
                self.lists[indexPath.row].isPinned = false
                RealmManager.commitWrite()
                self.readData()
            }
            
            let share = UIAction(title: AppLocalizationKeys.alertShare.localized(), image: UIImage(systemName: "arrowshape.turn.up.right")) { [weak self] _ in
                guard let self = self else { return }
                self.shareList(list: self.lists[indexPath.row])
            }
            
            let delete = UIAction(title: AppLocalizationKeys.delete.localized(), image: UIImage(systemName: "trash"), attributes: UIMenuElement.Attributes.destructive) { _ in
                let alert = UIAlertController(title: AppLocalizationKeys.confirm.localized(), message: AppLocalizationKeys.deleteEntry.localized(), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: AppLocalizationKeys.delete.localized(), style: .destructive, handler: { _ in
                    RealmManager.removeList(self.lists[indexPath.row])
                    self.readData()
                }))
                
                alert.addAction(UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .default))
                
                self.present(alert, animated: true)
            }
            
//            let linkShop = UIAction(title: self.lists[indexPath.row].linkedShopID == 0 ? AppLocalizationKeys.specifyStore.localized() : AppLocalizationKeys.untieStore.localized(), image: UIImage(systemName: "mappin.circle")) { [weak self] _ in
//
//                if self?.lists[indexPath.row].linkedShopID != 0 {
//                    RealmManager.beginWrite()
//                    self?.lists[indexPath.row].linkedShopID = 0
//                    RealmManager.commitWrite()
//                    self?.tableView.beginUpdates()
//                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//                    self?.tableView.endUpdates()
//                    return
//                }
//
//                let vc = ShopListController.loadFromNib()
//                vc.selectedShopBlock = { [weak self] selectedShop in
//                    RealmManager.beginWrite()
//                    self?.lists[indexPath.row].linkedShopID = selectedShop.id
//                    RealmManager.commitWrite()
//
//                    self?.tableView.beginUpdates()
//                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//                    self?.tableView.endUpdates()
//                }
//
//                self?.navigationController?.present(vc, animated: true)
//            }
            
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
