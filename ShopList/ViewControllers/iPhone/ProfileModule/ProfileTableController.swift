//
//  ProfileTableController.swift
//  ShopList
//
//  Created by Illia Romanenko on 29.07.22.
//

import Foundation
import UIKit

enum ProfilePoints {
    case name
    case accountStatus
    case listCounts
    
    case edit
    case removeAccount
    case logout
    
    static func getMenu() -> [[ProfilePoints]] {
        return [[.name, .accountStatus, .listCounts], [.edit, .removeAccount, .logout]]
    }
    
    var text: String {
        switch self {
        case .name:             return KeychainManager.username ?? "Неизвестно"
        case .accountStatus:    return "Аккаунт: базовый"
        case .listCounts:       return "Списки: 2/6"
        case .edit:             return "Редактировать"
        case .removeAccount:    return "Удалить аккаунт"
        case .logout:           return "Выйти"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .name:             return UIImage(systemName: "person.circle.fill")
        case .accountStatus:    return UIImage(systemName: "star.circle.fill")
        case .listCounts:       return UIImage(systemName: "list.bullet.circle.fill")
        case .edit:             return UIImage(systemName: "pencil.circle.fill")
        case .removeAccount:    return UIImage(systemName: "trash.circle.fill")
        case .logout:           return UIImage(systemName: "arrowshape.turn.up.left.circle.fill")
        }
    }
    
    var color: UIColor {
        switch self {
        case .removeAccount, .logout:
            return .red
        
        default:
            return .black
        }
    }
}

class ProfileTableController: UIViewController {
    
    private let menu = ProfilePoints.getMenu()
    
    var tableView: UITableView {
        let table = UITableView(frame: self.view.frame, style: .insetGrouped)
        table.dataSource = self
        table.delegate = self
        table.registerCellsWith([SettingCell.self])
        table.backgroundColor = .clear
        return table
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        title = "Профиль"
        self.view.backgroundColor = .white
    }
}

extension ProfileTableController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingCell = tableView.dequeueReusableCell(withIdentifier: SettingCell.id, for: indexPath) as! SettingCell
        settingCell.setupWith(menu[indexPath.section][indexPath.row])
        return settingCell
    }
    
    
}

extension ProfileTableController: UITableViewDelegate {
    
}
