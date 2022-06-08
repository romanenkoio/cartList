//
//  ShopListController.swift
//  ShopList
//
//  Created by Illia Romanenko on 1.05.22.
//

import UIKit

class ShopListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedShopBlock: ((SLRealmCoordinate) -> ())?
    var shops = [SLRealmCoordinate]()
    var selectedShop: SLRealmCoordinate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ваши магазины"
        tableView.register(UINib(nibName: ShopCell.cellID, bundle: nil), forCellReuseIdentifier: ShopCell.cellID)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readData()
        tableView.reloadData()
    }
    
    private func readData() {
        shops = RealmManager.read(type: SLRealmCoordinate.self)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let selectedShop = selectedShop else {
            return
        }

        selectedShopBlock?(selectedShop)
        dismiss(animated: true)
    }
}

extension ShopListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shopCell = tableView.dequeueReusableCell(withIdentifier: ShopCell.cellID, for: indexPath) as! ShopCell
        shopCell.setupWith(shops[indexPath.row])
        return shopCell
    }
}

extension ShopListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedShop = shops[indexPath.row]
    }
}
