//
//  ShopListController.swift
//  ShopList
//
//  Created by Illia Romanenko on 1.05.22.
//

import UIKit
import CoreLocation

class ShopListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private var locationBlock: ((CLLocationCoordinate2D, String) -> ())?
    private lazy var locationManager = CLLocationManager()
    var selectedShopBlock: ((SLRealmCoordinate) -> ())?
    var shops = [SLRealmCoordinate]()
    var selectedShop: SLRealmCoordinate?
    var isAdding = false
    
    class func customInit(isAdding: Bool = false) -> ShopListController {
        let vc = ShopListController.loadFromNib()
        vc.isAdding = isAdding
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ваши магазины"
        tableView.register(UINib(nibName: ShopCell.cellID, bundle: nil), forCellReuseIdentifier: ShopCell.cellID)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        addButton.setTitle(isAdding ? "Добавить" : "Выбрать", for: .normal)
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
        if isAdding {
            let alert = Alerts.mapType.controller
            
            let mapAction = UIAlertAction(title: "Выбрать на карте", style: .default, handler: { [weak self] _ in

            })
            mapAction.setValue(UIColor.mainOrange, forKeyPath: "titleTextColor")
            alert.addAction(mapAction)
            
            let locationAction = UIAlertAction(title: "Добавить текущую локацию", style: .default, handler: { _ in
                self.locationManager.delegate = self
                self.locationManager.startUpdatingLocation()
            })
            locationAction.setValue(UIColor.mainOrange, forKeyPath: "titleTextColor")
            alert.addAction(locationAction)
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            self.present(alert, animated: true)
        } else {
            guard let selectedShop = selectedShop else {
                return
            }

            selectedShopBlock?(selectedShop)
            dismiss(animated: true)
        }
    
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

extension ShopListController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        locationManager.stopUpdatingLocation()
        let alert = UIAlertController(title: "Имя сохранённой точки", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Название магазина"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
      
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            guard let text = textField?.text else { return }
            let coord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            RealmManager.write(object: SLRealmCoordinate(marketName: text, lat: "\(coord.latitude)", lon: "\(coord.longitude)"))
            NotificationManager.scheduleLocationNotifications()
            
        }))

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alert.addAction(cancelAction)
        self.present(alert, animated: true)
       
    }
}
