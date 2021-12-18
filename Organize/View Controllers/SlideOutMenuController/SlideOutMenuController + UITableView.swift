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
        tableView.register(ListLabelCell.self, forCellReuseIdentifier: "list-label-cell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if indexPath.row != 0 {
            if let indexPathOfPreviouslySelectedRow = indexPathOfPreviouslySelectedRow {
                if let previouslySelectedCell = tableView.cellForRow(at: indexPathOfPreviouslySelectedRow) {
                    previouslySelectedCell.isSelected = false
                }
            }
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.isSelected = true
            indexPathOfPreviouslySelectedRow = indexPath
            selectListDelegate?.didSelectList(list: toDoItemLists[indexPath.row - 1])
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "profile-cell") as? ProfileTableViewHeader {
                        
            if let user = Auth.auth().currentUser, let email = user.email {
                cell.emailLabel.text = email
                
                let attributedString1 = NSAttributedString(string: email)
                let attributedString2 = NSAttributedString(string: "\nYour Tier: Free", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.5, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1), NSAttributedString.Key.baselineOffset: -10])
                let mutableStringArray = NSMutableAttributedString()
                mutableStringArray.append(attributedString1)
                mutableStringArray.append(attributedString2)
                
                cell.emailLabel.attributedText = mutableStringArray
            }
            
            return cell
        }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "profile-cell") as? ProfileTableViewHeader
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "list-label-cell", for: indexPath)
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "list-cell", for: indexPath) as? ListTableViewCell {
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets.zero
                
                if !toDoItemLists.isEmpty {
                    cell.listNameLabel.text = toDoItemLists[indexPath.row - 1].name
                }
                
                return cell
            }
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "list-cell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "create-list-cell") as? CreateListTableViewFooter {
            cell.createNewListButton.addTarget(self, action: #selector(handleCreateNewListTap), for: .touchUpInside)
            return cell
        }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "create-list-cell")
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemLists.count + 1
    }
    
}
