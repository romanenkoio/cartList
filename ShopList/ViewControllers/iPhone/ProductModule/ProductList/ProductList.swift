//
//  ProductList.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit
import Lottie
import Vision
import Firebase

class ProductList: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var refreshListButton: UIButton!
    @IBOutlet var pasteButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var mainShopContainer: UIView!
    @IBOutlet weak var subContainer: UIView!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var addProductButton: UIButton!
    
    private let imagePicker = UIImagePickerController()

    private var products = [SLFirebaseProduct]() {
        didSet {
            tableView.reloadData()
            playAnimation()
            if products.count > 0 {
                self.navigationItem.rightBarButtonItems = [
                    UIBarButtonItem(customView: pasteButton),
                    UIBarButtonItem(customView: refreshListButton)
                ]
            } else {
                self.navigationItem.rightBarButtonItems = [
                    UIBarButtonItem(customView: pasteButton)
                ]
            }
        }
    }
    
    var currentList: SLFirebaseList?
    var database: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCellsWith([ProductCell.self])
        updateLanguage()
        subscribeToNotification()
        if #available(iOS 15.0, *){
            self.tableView.sectionHeaderTopPadding = 0.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readData()
    }

    private func playAnimation() {
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 0.5
        animationView.animation = Animation.named("emptyList")
        products.count > 0 ? animationView.stop() : animationView.play()
        animationView.isHidden = products.count != 0
        emptyLabel.isHidden = products.count != 0
    }
    
    private func readData() {
        
    }
    
    private func updateCellAt(_ indexPath: IndexPath) {
        if DefaultsManager.separateProducts {
            tableView.beginUpdates()
            tableView.reloadSections([0, 1], with: .fade)
            tableView.endUpdates()
        } else {
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    @IBAction func addProductAction(_ sender: Any) {
        let vc = AddListController.loadFromNib()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.currentList = currentList
        vc.type = .product
        vc.saveAction = { [weak self] in
            self?.readData()
            self?.dismiss(animated: true)
        }
        self.present(vc, animated: true)
    }
    
//    MARK: rewrite this function to FB logic
    @IBAction func createFromPasteBoard(_ sender: Any) {
//        guard let content = UIPasteboard.general.string,
//              let list = currentList
//        else { return }
//
//        let spliceContent = content.components(separatedBy: "\n")
//        for item in spliceContent {
//            if !item.isEmpty, item != "\n" {
//                RealmManager.write(object: SLRealmProduct(productName: item.capitalizingFirstLetter(), produckPkg: "", productCount: 0, listID: list.id))
//            }
//        }
//        readData()
    }
    
    //    MARK: rewrite this function to FB logic
//    @IBAction func refreshListAction(_ sender: Any) {
//        guard let list = currentList else {
//            return
//        }
//
//        let alert = Alerts.refresh.controller
//
//        let refreshAction = UIAlertAction(title: AppLocalizationKeys.clearProgress.localized(), style: .default, handler: { [weak self] _ in
//            guard let self = self else { return }
//
//            self.products = RealmManager.read(type: SLRealmProduct.self).filter({ $0.ownerListID == list.id })
//            RealmManager.beginWrite()
//            for item in self.products {
//                item.checked = false
//            }
//            RealmManager.commitWrite()
//            self.tableView.reloadData()
//        })
//        refreshAction.setValue(UIColor.mainOrange, forKeyPath: "titleTextColor")
//
//        let cancelAction = UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .cancel)
//        cancelAction.setValue(UIColor.black, forKeyPath: "titleTextColor")
//
//        alert.addAction(cancelAction)
//        alert.addAction(refreshAction)
//
//        self.present(alert, animated: true)
//    }
    
    @objc private func updateLanguage() {
        emptyLabel.text = AppLocalizationKeys.emptyLabel.localized()
        addProductButton.setTitle(AppLocalizationKeys.addProduct.localized(), for: .normal)
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .languageChange, object: nil)
    }
}

extension ProductList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if DefaultsManager.separateProducts {
            if section == 0 {
                return AppLocalizationKeys.needToBuy.localized()
            }
            return AppLocalizationKeys.bought.localized()
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        
        if DefaultsManager.separateProducts {
            if section == 0 {
                return currentList?.products.filter({ !$0.checked }).count == 0 ? CGFloat.leastNonzeroMagnitude  : 30
            }
            return currentList?.products.filter({ $0.checked }).count == 0 ? CGFloat.leastNonzeroMagnitude  : 30
        }
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if DefaultsManager.separateProducts {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if DefaultsManager.separateProducts {
            if section == 0 {
                return currentList?.products.filter({ !$0.checked}).count ?? 0
            }
            return currentList?.products.filter({ $0.checked}).count ?? 0
        }
        return currentList?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCell.self), for: indexPath) as! ProductCell
        
        let item = currentList?.products[indexPath.row]
        
        productCell.updateBlock = { [weak self] indexPath in
            guard let self = self else { return }
            
            self.updateCellAt(indexPath)
    
            
            if self.currentList?.products.count == self.currentList?.products.filter({ $0.checked }).count, DefaultsManager.autoDelete {
                guard let list = self.currentList else { return }
                    
                let alert = Alerts.information(text: AppLocalizationKeys.deleteList.localized()).controller
                let okAction = UIAlertAction(title: AppLocalizationKeys.delete.localized(), style: .destructive) { _ in
                    // delete product action
                    self.navigationController?.popViewController(animated: true)
                }
                
                let cancelAction = UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .cancel)
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
            
        }
        if let item = item {
            productCell.setupWithFB(item, indexPath)
        }
        
        return productCell
    }
}

extension ProductList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {  [weak self] _ in
            guard let self = self else { return nil }
            
            let delete = UIAction(title: AppLocalizationKeys.delete.localized(), image: UIImage(systemName: "trash"), attributes: UIMenuElement.Attributes.destructive) { _ in
                let alert = UIAlertController(title: AppLocalizationKeys.confirm.localized(), message: AppLocalizationKeys.deleteEntry.localized(), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: AppLocalizationKeys.delete.localized(), style: .destructive, handler: { _ in
                    tableView.beginUpdates()
                                        
                    if indexPath.section == 0 {
//                       прописать логику удаления продукта
                    } else if indexPath.section == 1 {
                        //                       прописать логику удаления продукта
                    }
                    
                    tableView.deleteRows(at: [indexPath], with: .left)
                    self.readData()
                    tableView.endUpdates()
                    
                }))
                
                alert.addAction(UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .default))
                self.present(alert, animated: true)
            }
            
            return UIMenu(title: "", children: [delete])
        }
        return configuration
    }
}
