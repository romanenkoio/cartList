//
//  SettingsController.swift
//  ShopList
//
//  Created by Illia Romanenko on 22.04.22.
//

import UIKit
import EasyTipView
import Alamofire

class SettingsController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var points = SLSettingsPoint.allCases
    private var timePicker = UIDatePicker()
    private var radiusPicker = UIPickerView()
    private var toolBar = UIToolbar()
    var tipViews = [EasyTipView]()
    private let radiuses = [100, 200, 300, 500, 1000]
    private var selectedRadius = 100
    private let languages = Languages.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellsWith([SettingCell.self, SettingsHeaderCell.self])
        setupDatePicker()
        setupRadiusPicker()
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        showTips()
        updateLanguage()
        subscribeToNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for view in tipViews {
            view.removeFromSuperview()
        }
    }
    
    private func setupDatePicker() {
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
    }
    
    private func setupRadiusPicker() {
        radiusPicker.delegate = self
        radiusPicker.dataSource = self
        radiusPicker.backgroundColor = .white
    }
    
    private func showTips() {
        if DefaultsManager.isFirstSettingsLaunch {
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
                guard let self = self else { return }

                let tipView = EasyTipView(text: AppLocalizationKeys.deleteCompletedList.localized(),
                                          preferences: EasyTipView.globalPreferences,
                                          delegate: nil)
                guard let firstCell = self.tableView.cellForRow(at: IndexPath(item: 1, section: 0)) else { return }
                tipView.show(forView: firstCell)
                self.tipViews.append(tipView)
                DefaultsManager.isFirstSettingsLaunch = false
            }
        }
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        radiusPicker.removeFromSuperview()
        DefaultsManager.baseRadius = selectedRadius
        NotificationManager.scheduleLocationNotifications()
        tableView.reloadData()
    }
    
    private func showPicker() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottomPoint = (window?.safeAreaInsets.bottom ?? 0) + (self.tabBarController?.tabBar.frame.height ?? 49.0) + 440
        self.radiusPicker.frame = CGRect(x: 0.0, y: bottomPoint, width: UIScreen.main.bounds.size.width, height: 200)
        self.view.addSubview(self.radiusPicker)
        toolBar = UIToolbar(frame: CGRect.init(x: 0.0, y: bottomPoint, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.backgroundColor = .mainOrange
        let button = UIBarButtonItem(title: AppLocalizationKeys.save.localized(), style: .done, target: self, action: #selector(onDoneButtonTapped))
        button.tintColor = .black
        toolBar.items = [button]
        self.view.addSubview(toolBar)
    }
    
    @objc  func updateLanguage() {
        self.title = AppLocalizationKeys.settings.localized()
        tableView.reloadData()
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .languageChange, object: nil)
    }
}

extension SettingsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var settingCell: UITableViewCell
        
        switch points[indexPath.row] {
        case .authHeader,.listHeader, .notificationHeader, .infoHeader:
            settingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsHeaderCell.self), for: indexPath) as! SettingsHeaderCell
            (settingCell as! SettingsHeaderCell).setupWith(type: points[indexPath.row])
        case .signing, .registation, .autoDelete, .useTimePush, .morningTime, .version, .separateList, .language:
            settingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingCell.self), for: indexPath) as! SettingCell
            
            (settingCell as! SettingCell).setupWith(points[indexPath.row])
            
            (settingCell as! SettingCell).switchAction = { [weak self] isOn in
                guard let self = self else { return }
                
                switch self.points[indexPath.row] {
                    
                case .autoDelete:
                    DefaultsManager.autoDelete = !DefaultsManager.autoDelete
//                case .useLocationPush:
//                    DefaultsManager.notificationByLocation = !DefaultsManager.notificationByLocation
//                    NotificationManager.scheduleLocationNotifications()
                case .useTimePush:
                    DefaultsManager.timeNotification = !DefaultsManager.timeNotification
                    NotificationManager.scheduleTimeNotifications()
                case .separateList:
                    DefaultsManager.separateProducts = !DefaultsManager.separateProducts
                default: break
              
                }
                self.tableView.reloadData()
            }
        }

        return settingCell
    }
}

extension SettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.points[indexPath.row] {
            
        case .morningTime:
            guard DefaultsManager.timeNotification else { return }
            let timeVC = TimeSelectPopupController.loadFromNib()
            timeVC.modalPresentationStyle = .overCurrentContext
            timeVC.modalTransitionStyle = .crossDissolve
            
            timeVC.voidBlock = { [weak self] in
                self?.tableView.reloadData()
                NotificationManager.scheduleTimeNotifications()
                self?.dismiss(animated: true)
            }
            self.present(timeVC, animated: true)
        case .language:
            let alert = UIAlertController(title: "", message: AppLocalizationKeys.chooseLanguage.localized(), preferredStyle: .actionSheet)
            
            for lang in languages {
                let action = UIAlertAction(title: lang.rawValue, style: .default) { _ in
                    print("\(AppLocalizationKeys.setLanguage.localized()): \(lang.rawValue)")
                    Bundle.setLanguage(lang: lang.short)
                }
                alert.addAction(action)
            }
            alert.addAction(UIAlertAction(title: AppLocalizationKeys.back.localized(), style: .cancel))
            self.present(alert, animated: true)
            
        case .signing:
            if KeychainManager.UID != nil {
                let logoutAlert = Alerts.confirmation.controller
                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
                let logoutAction = UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
                    KeychainManager.clearAll()
                    self?.tableView.reloadData()
                }
                logoutAlert.addAction(cancelAction)
                logoutAlert.addAction(logoutAction)
                present(logoutAlert, animated: true)
            
                return
            }
            
            let signInVC = AuthViewController.loadFromNib()
            signInVC.type = .login
            signInVC.loginSuccess = { [weak self] in
                self?.tableView.reloadData()
            }
            signInVC.modalTransitionStyle = .coverVertical
            signInVC.modalPresentationStyle = .overFullScreen
            self.present(signInVC, animated: true)
            
        case .registation:
            if KeychainManager.UID != nil {
                let deleteAlert = Alerts.deleteConfirmation.controller
                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
                let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
//                    удаление аккаунта тут
                }
                deleteAlert.addAction(cancelAction)
                deleteAlert.addAction(deleteAction)
                present(deleteAlert, animated: true)

                return
            }
            
            let authVC = AuthViewController.loadFromNib()
            authVC.type = .registration
            authVC.loginSuccess = { [weak self] in
                self?.tableView.reloadData()
            }
            authVC.modalTransitionStyle = .coverVertical
            authVC.modalPresentationStyle = .overFullScreen
            self.present(authVC, animated: true)
            
            default: break
        }
    }
}

extension SettingsController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return radiuses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRadius = radiuses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(radiuses[row])"
    }
}
