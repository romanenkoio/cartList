//
//  SarchUserController.swift
//  ShopList
//
//  Created by Illia Romanenko on 29.07.22.
//

import UIKit

class SearchUserController: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var isManage = false
    var litsID: String?
    
    var findedUser: [SLUser] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var users: [SLUser] = []
    
    var selectionBlock: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerCellsWith([UserSearchCell.self])
        searchBar.delegate = self
        searchBar.isHidden = isManage
        title = AppLocalizationKeys.manageUsers.localized()
        users = users.sorted(by: { $0.name ?? "" < $1.name ?? "" })
    }
    
    private func findUser() {
        spinner.startAnimating()
        guard let text = searchBar.text else {
            spinner.stopAnimating()
            return
        }
    
        SLFirManager.userByEmail(text.lowercased()) { [weak self] user in
            self?.spinner.stopAnimating()
            self?.findedUser.removeAll()
            self?.findedUser.append(user)
        } fail: { [weak self] in
            self?.spinner.stopAnimating()
            self?.findedUser.removeAll()
        }
    }
    
    private func updateRecent(with id: String) {
        if !DefaultsManager.recentUsersId.contains(id) {
            
            if DefaultsManager.recentUsersId.count == 5 {
                DefaultsManager.recentUsersId.remove(at: 0)
            }
            
            DefaultsManager.recentUsersId.append(id)
        }
    }
}

extension SearchUserController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isManage ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isManage {
            return users.count
        } else {
            if section == 0 {
                return findedUser.count
            } else {
                return DefaultsManager.recentUsersId.count > 5 ? 5 : DefaultsManager.recentUsersId.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserSearchCell.id, for: indexPath) as! UserSearchCell
        if indexPath.section == 0 {
            cell.setupWith(user: isManage ? users[indexPath.row] : findedUser[indexPath.row], isManage: isManage)
            if isManage {
                cell.removeBlock = { [weak self] userID  in
                    guard let index = self?.users.firstIndex(where: { $0.uid == userID }) else { return }
                    self?.users.remove(at: index)
                    self?.tableView.reloadData()
                }
                cell.listID = litsID
                cell.userID = users[indexPath.row].uid
            }
        } else if indexPath.section == 1 {
            cell.setupWith(userID: DefaultsManager.recentUsersId.reversed()[indexPath.row])
            return cell
        }
     
        return cell
    }
}

extension SearchUserController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if findedUser.count == 0 {
            let id = DefaultsManager.recentUsersId.reversed()[indexPath.row]
            selectionBlock?(id)
            updateRecent(with: id)
        } else if findedUser.count == 1 {
            if indexPath.section == 0 {
                selectionBlock?(findedUser[0].uid!)
                updateRecent(with: findedUser[0].uid!)
            } else if indexPath.section == 1 {
                let id = DefaultsManager.recentUsersId.reversed()[indexPath.row]
                selectionBlock?(id)
                updateRecent(with: id)
            }
        }
        
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isManage {
            return ""
        } else {
            if section == 0 {
                return findedUser.count == 0 ? "" : "Пользователи по вашему запросу"
            } else {
                return DefaultsManager.recentUsersId.count == 0 ? "" : "Недавно добавленные"
            }
        }
    }
}

extension SearchUserController: UISearchBarDelegate {
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        self.findUser()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.findUser()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.findedUser = []
            self.tableView.reloadData()
        }
        findUser()
    }
}
