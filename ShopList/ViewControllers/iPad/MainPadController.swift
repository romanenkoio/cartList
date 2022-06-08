//
//  MainPadController.swift
//  ShopList
//
//  Created by Illia Romanenko on 28.04.22.
//

import UIKit

class MainPadController: UIViewController {
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productsListTableView: UITableView!
    
    private var selectedList: SLRealmList?
    
    var lists = RealmManager.read(type: SLRealmList.self) {
        didSet {
            listTableView.reloadData()
        }
    }
    var products = [SLRealmProduct]() {
        didSet {
            productsListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.dataSource = self
        productsListTableView.dataSource = self
        listTableView.delegate = self
        listTableView.registerCellsWith([MainListCell.self])
        productsListTableView.registerCellsWith([ProductCell.self])
    }
    
    private func updateCellAt(_ indexPath: IndexPath) {
        productsListTableView.beginUpdates()
        productsListTableView.reloadRows(at: [indexPath], with: .automatic)
        productsListTableView.endUpdates()
        
        guard let selectedList = selectedList,
        let index = lists.firstIndex(of: selectedList) else {
            return
        }

        listTableView.beginUpdates()
        listTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        listTableView.endUpdates()
    }
}

extension MainPadController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == listTableView {
            return lists.count
        } else if tableView == productsListTableView {
            return products.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == listTableView {
            
            let listCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainListCell.self), for: indexPath) as! MainListCell
            listCell.setupWith(lists[indexPath.row])
            return listCell
        } else if tableView == productsListTableView {
            let productCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCell.self), for: indexPath) as! ProductCell
            productCell.updateBlock = { [weak self] indexPath in
                guard let self = self,
                      let selectedList = self.selectedList
                else { return }
                
                self.updateCellAt(indexPath)
                if self.products.count == self.products.filter({ $0.checked }).count, DefaultsManager.autoDelete {
                    
                    let alert = Alerts.information(text: "Удалить список?").controller
                    let okAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                        RealmManager.removeList(selectedList)
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                }
            }
            productCell.setupWith(products[indexPath.row], indexPath)
            return productCell
        }
        return UITableViewCell()
    }
}

extension MainPadController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == listTableView {
            self.selectedList = lists[indexPath.row]
            self.products = RealmManager.read(type: SLRealmProduct.self).filter({ $0.ownerListID == lists[indexPath.row].id})
        }
    }
}

