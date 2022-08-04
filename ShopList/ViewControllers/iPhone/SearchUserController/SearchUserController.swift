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
    
    var findedUser: SLUser? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var selectionBlock: ((SLUser) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCellsWith([UserSearchCell.self])
        searchBar.delegate = self
    }
    
    private func findUser() {
        spinner.startAnimating()
        guard let text = searchBar.text else {
            spinner.stopAnimating()
            return
        }
    
        SLFirManager.userByEmail(text.lowercased()) { [weak self] user in
            self?.spinner.stopAnimating()
            self?.findedUser = user
        } fail: { [weak self] in
            self?.spinner.stopAnimating()
            self?.findedUser = nil
        }
    }
}

extension SearchUserController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return findedUser == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserSearchCell.id, for: indexPath) as! UserSearchCell
        cell.setupWith(user: findedUser!)
        return cell
    }
}

extension SearchUserController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedUser = findedUser else { return }
        selectionBlock?(selectedUser)
        dismiss(animated: true)
    }
}

extension SearchUserController: UISearchBarDelegate {
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        self.findUser()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.findedUser = nil
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.findUser()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.findedUser = nil
            self.tableView.reloadData()
        }
        findUser()
    }
}
