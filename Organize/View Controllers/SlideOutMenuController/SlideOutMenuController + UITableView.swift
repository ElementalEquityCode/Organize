//
//  SlideOutMenuController + UITableView.swift
//  Organize
//
//  Created by Daniel Valencia on 7/23/21.
//

import UIKit
import FirebaseAuth

extension SlideOutMenuController {
    
    func setupTableView() {
        tableView.register(ProfileTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "profile-cell")
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "list-cell")
        tableView.register(CreateListTableViewFooter.self, forHeaderFooterViewReuseIdentifier: "create-list-cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.black.withAlphaComponent(0.3)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        selectListDelegate?.didSelectList(list: toDoItemLists[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "profile-cell") as? ProfileTableViewHeader {
            cell.closeMenuButton.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
            cell.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPHPickerViewController)))
                        
            if let user = Auth.auth().currentUser, let email = user.email {
                cell.emailLabel.text = email
                cell.logoutButton.addTarget(self, action: #selector(handleSignout), for: .touchUpInside)
            }
            
            return cell
        }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "profile-cell") as? ProfileTableViewHeader
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "list-cell", for: indexPath) as? ListTableViewCell {
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets.zero
            
            if !toDoItemLists.isEmpty {
                cell.listNameLabel.text = toDoItemLists[indexPath.row].name
            }
            
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "list-cell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "create-list-cell") as? CreateListTableViewFooter {
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCreateNewListTap)))
            
            return cell
        }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "create-list-cell")
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemLists.count
    }
    
}
