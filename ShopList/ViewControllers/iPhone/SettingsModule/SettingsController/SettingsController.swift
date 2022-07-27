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
    
    private var points = SLSettingsPoint.getMenu()
    private var timePicker = UIDatePicker()
    var tipViews = [EasyTipView]()
    private let languages = Languages.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellsWith([SettingCell.self, SettingsHeaderCell.self, ProfileCell.self])
        tableView.sectionFooterHeight = 20
        setupDatePicker()
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
    
    @objc  func updateLanguage() {
        self.title = AppLocalizationKeys.settings.localized()
        tableView.reloadData()
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .languageChange, object: nil)
    }
}

extension SettingsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var settingCell: UITableViewCell
  
        let point = points[indexPath.section][indexPath.row]
        switch point {
        case .profile:
            settingCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.id, for: indexPath)
        case .autoDelete, .useTimePush, .morningTime, .version, .separateList, .language:
            settingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingCell.self), for: indexPath) as! SettingCell
            
            (settingCell as! SettingCell).setupWith(point)
            
            (settingCell as! SettingCell).switchAction = { [weak self] isOn in
                guard let self = self else { return }
                
                switch point {
                case .autoDelete:
                    DefaultsManager.autoDelete = !DefaultsManager.autoDelete
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

        settingCell.contentView.backgroundColor = .systemGray6
        return settingCell
    }
}

extension SettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.points[indexPath.section][indexPath.row] {
            
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
        case .profile:
            let authController = AuthViewController.loadFromNib()
            
            let alert = Alerts.auth.controller
            let loginAction = UIAlertAction(title: "Войти", style: .default) { [weak self] _ in
                authController.type = .login
                self?.present(authController, animated: true)
            }
            
            let registrationAction = UIAlertAction(title: "Регистрация", style: .default) { [weak self]  _ in
                authController.type = .registration
                self?.present(authController, animated: true)
            }
            
            let cancelAction = UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .cancel)
            
            alert.addAction(loginAction)
            alert.addAction(registrationAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        default: break
        }
    }
}
