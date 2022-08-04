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

class ProductList: BaseViewController {
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
    var database: DatabaseReference!
    
    var currentList: SLFirebaseList? {
        didSet {
            if self.isViewLoaded {
                tableView.reloadData()
                emptyLabel.isHidden = currentList?.products.count == 0
                animationView.isHidden = currentList?.products.count == 0
            }
        }
    }
    
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
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0.0
        }
        readData()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playAnimation()
    }
    
    private func setupNavigationButton() {
        if currentList?.products.count ?? 0 > 0 {
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

    private func playAnimation() {
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 0.5
        animationView.animation = Animation.named("emptySearch")
        currentList?.products.count ?? 0 > 0 ? animationView.stop() : animationView.play()
        animationView.isHidden = currentList?.products.count != 0
        emptyLabel.isHidden = currentList?.products.count != 0
    }
    
    private func readData() {
        guard let currentList = currentList, let id = currentList.id else {
            return
        }

        SLFirManager.loadList(id: id) { [weak self] list in
            self?.currentList?.products = list
            self?.tableView.reloadData()
            self?.setupNavigationButton()
            self?.playAnimation()
        }
    }
    
    private func updateCellAt(_ indexPath: IndexPath) {
        tableView.beginUpdates()
        DefaultsManager.separateProducts ? tableView.reloadSections([0, 1], with: .fade) : tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    @IBAction func addProductAction(_ sender: Any) {
        let vc = AddListController.loadFromNib()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.currentList = currentList
        vc.type = .product
        vc.saveAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func createFromPasteBoard(_ sender: Any) {
        guard let content = UIPasteboard.general.string,
              let list = currentList
        else { return }
        
        let spliceContent = content.components(separatedBy: "\n")
        for item in spliceContent {
            if !item.isEmpty, item != "\n" {
                let product  = SLFirebaseProduct(productName: item.capitalizingFirstLetter(), produckPkg: "", productCount: 0, checked: false)
                SLFirManager.addProductToList(list.id!, product: product)
            }
        }
    }
    
    @IBAction func refreshListAction(_ sender: Any) {
        guard let currentList = currentList else {
            return
        }

        for product in currentList.products {
            product.checked = false
            SLFirManager.updateProduct(product, listID: currentList.id!)
        }
    }
    
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
        return DefaultsManager.separateProducts ? 2 : 1
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
        
        
        var item: SLFirebaseProduct!
        
        if tableView.numberOfSections == 1 {
            item = currentList?.products[indexPath.row]
        } else {
            if indexPath.section == 0 {
                item = currentList?.products.filter({ !$0.checked })[indexPath.row]
            } else {
                item = currentList?.products.filter({ $0.checked })[indexPath.row]
            }
        }
        
        productCell.updateBlock = { [weak self] indexPath in
            guard let self = self else { return }
            
            self.updateCellAt(indexPath)
    
            
            if self.currentList?.products.count == self.currentList?.products.filter({ $0.checked }).count, DefaultsManager.autoDelete {
                guard let list = self.currentList else { return }
                    
                let alert = Alerts.information(text: AppLocalizationKeys.deleteList.localized()).controller
                let okAction = UIAlertAction(title: AppLocalizationKeys.delete.localized(), style: .destructive) { _ in
                    SLFirManager.removeList(list) { success in
                        if success {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
                let cancelAction = UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .cancel)
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
            
        }
        if let item = item {
            productCell.listID = currentList?.id
            productCell.ownerID = currentList?.ownerid
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
                    var item: SLFirebaseProduct!
                    
                    if tableView.numberOfSections == 1 {
                        item = self.currentList?.products[indexPath.row]
                    } else {
                        if indexPath.section == 0 {
                            item = self.currentList?.products.filter({ !$0.checked })[indexPath.row]
                        } else {
                            item = self.currentList?.products.filter({ $0.checked })[indexPath.row]
                        }
                    }
                    
                    SLFirManager.removeProduct(item, listID: (self.currentList?.id!)!)
                }))
                
                alert.addAction(UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .default))
                self.present(alert, animated: true)
            }
            
            return UIMenu(title: "", children: [delete])
        }
        return configuration
    }
}
