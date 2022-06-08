//
//  MapViewController.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.04.22.
//

import UIKit
import GoogleMaps
import CoreLocation
import EasyTipView

class MapViewController: UIViewController {
    @IBOutlet var plusButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapButton: UIButton!
    
    var tipViews = [EasyTipView]()
    private var locationManager: CLLocationManager!
    private var savedPlaces = RealmManager.read(type: SLRealmCoordinate.self) {
        didSet {
            setupPoints()
        }
    }
    private var locationBlock: ((CLLocationCoordinate2D, String) -> ())?
    private var markers = [GMSMarker]()
    private var isSelectingEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ваши магазины"
        mapButton.layer.borderColor = UIColor.mainOrange.cgColor
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: plusButton)]
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        locationBlock = { [weak self] coordinate, name in
            self?.isSelectingEnabled = false
            RealmManager.write(object: SLRealmCoordinate(marketName: name, lat: "\(coordinate.latitude)", lon: "\(coordinate.longitude)"))
            NotificationManager.scheduleLocationNotifications()
            self?.savedPlaces = RealmManager.read(type: SLRealmCoordinate.self)
        }
        savedPlaces = RealmManager.read(type: SLRealmCoordinate.self)
        showTips()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for view in tipViews {
            view.removeFromSuperview()
        }
    }
    
    private func showTips() {
        if DefaultsManager.isMapListLaunch {
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
                guard let self = self else { return }

                var preferences = EasyTipView.globalPreferences
                preferences.drawing.backgroundColor = .white
                let tipView = EasyTipView(text: "Воспользуйтесь этой кнопкой для сохранения локации магазина",
                                          preferences: preferences,
                                          delegate: nil)
              
                tipView.show(forView: self.plusButton)
                self.tipViews.append(tipView)
                DefaultsManager.isMapListLaunch = false
            }
        }
    }
    
    @IBAction func centerMapAction(_ sender: Any) {
        guard let myLoc = mapView.myLocation?.coordinate  else { return }
            
        let camera = GMSCameraPosition(latitude: myLoc.latitude, longitude: myLoc.longitude, zoom: 14)
        mapView.animate(to: camera)
    }
    
    private func setupPoints() {
        markers = []
        mapView.clear()
        for place in savedPlaces {
            let marker = ShopMarker(position: CLLocationCoordinate2D(latitude: Double(place.lat)!, longitude: Double(place.lon)!))
            markers.append(marker)
            marker.shop = place
            marker.title = place.marketName
            marker.map = mapView
            let markerView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            markerView.image = SLAppImages.storeIcon.image
            markerView.tintColor = .mainOrange
            markerView.layer.cornerRadius = 20
            markerView.layer.borderWidth = 1
            markerView.contentMode = .scaleAspectFit
            markerView.backgroundColor = .white
            markerView.borderColor = UIColor.lightGray.cgColor
            marker.iconView = markerView
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupCamera()
        }
    }
    
    private func setupCamera() {
        if let firstPos = markers.first?.position {
            var bounds = GMSCoordinateBounds(coordinate: firstPos, coordinate: firstPos)
            for marker in markers {
                bounds = bounds.includingCoordinate(marker.position)
            }
            if let myLoc = mapView.myLocation?.coordinate {
                bounds = bounds.includingCoordinate(myLoc)
            }
            let insets = UIEdgeInsets(top: 60, left: 40, bottom:  30, right: 40)
            let update = GMSCameraUpdate.fit(bounds, with: insets)
            mapView.animate(with: update)
        } else {
            guard let myLoc = mapView.myLocation?.coordinate  else { return }
                
            let camera = GMSCameraPosition(latitude: myLoc.latitude, longitude: myLoc.longitude, zoom: 14)
            mapView.animate(to: camera)
        }
    }
    
    @IBAction func addPlaceAction(_ sender: Any) {
        let alert = Alerts.mapType.controller
        
        let mapAction = UIAlertAction(title: "Выбрать на карте", style: .default, handler: { [weak self] _ in
            self?.isSelectingEnabled = true
        })
        mapAction.setValue(UIColor.mainOrange, forKeyPath: "titleTextColor")
        alert.addAction(mapAction)
        
        let locationAction = UIAlertAction(title: "Добавить текущую локацию", style: .default, handler: { _ in
            self.locationManager.startUpdatingLocation()
        })
        locationAction.setValue(UIColor.mainOrange, forKeyPath: "titleTextColor")
        alert.addAction(locationAction)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        self.present(alert, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
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
            self.locationBlock?(coord, text)
        }))

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alert.addAction(cancelAction)
        self.present(alert, animated: true)
       
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let marker = marker as? ShopMarker,
              let shop = marker.shop
        else { return false }
        
        let alert = Alerts.information(text: "Удалить \(shop.marketName)?").controller
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            
            if let list = RealmManager.read(type: SLRealmList.self).filter({ $0.linkedShopID == shop.id }).first {
                RealmManager.beginWrite()
                list.linkedShopID = 0
                RealmManager.commitWrite()
            }
            
            RealmManager.delete(object: shop)
            self.savedPlaces = RealmManager.read(type: SLRealmCoordinate.self)
        }))
        
        self.present(alert, animated: true)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if isSelectingEnabled {
            let alert = UIAlertController(title: "Имя сохранённой точки", message: "", preferredStyle: .alert)

            alert.addTextField { (textField) in
                textField.placeholder = "Название магазина"
                textField.autocorrectionType = .yes
                textField.autocapitalizationType = .sentences
            }
          
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                guard let text = textField?.text else { return }
                self.isSelectingEnabled = false
                self.locationBlock?(coordinate, text)
            }))

            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
    
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
    }
}
