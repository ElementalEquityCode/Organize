//
//  HomeController + UICollectionView.swift
//  Organize
//
//  Created by Daniel Valencia on 7/22/21.
//

import UIKit

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        toDoItemsCollectionView.delegate = self
        toDoItemsCollectionView.dataSource = self
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if toDoItemLists.isEmpty {
                return 0
            } else {
                if currentlyViewedList != nil {
                    return currentlyViewedList!.toDoItems.count
                } else {
                    return 0
                }
            }
        } else {
            if currentlyViewedList != nil {
                return currentlyViewedList!.completedToDoItems.count
            } else {
                return 0
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ToDoListItemsCollectionViewCell {
            cell.delegate = self
            
            if isEditingCollectionView {
                cell.animateCheckmarkView(isHidden: true)
                cell.isSelectable = true
            } else {
                cell.isSelectable = false
                if !cell.checkMarkView.isHidden {
                    cell.animateCheckmarkView(isHidden: false)
                }
            }
                            
            if currentlyViewedList != nil {
                if let index = toDoItemLists.firstIndex(of: currentlyViewedList!) {
                    cell.checkMarkView.primaryColorForCell = index % 2 == 0 ? .primaryColor : .secondaryColor
                }
                
                if indexPath.section == 0 {
                    cell.toDoItem = currentlyViewedList!.toDoItems[indexPath.row]
                } else {
                    cell.toDoItem = currentlyViewedList!.completedToDoItems[indexPath.row]
                }
            }
            
            return cell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        if !isEditingCollectionView {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Edit Item", style: .default, handler: { (_) in
                if self.currentlyViewedList != nil {
                    let toDoItem = indexPath.section == 0 ? self.currentlyViewedList!.toDoItems[indexPath.row] : self.currentlyViewedList!.completedToDoItems[indexPath.row]
                    let viewController = UINavigationController(rootViewController: EditToDoItemController(toDoItem: toDoItem, delegate: self, indexPath: indexPath))
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete Item", style: .destructive, handler: { (_) in
                if self.currentlyViewedList != nil {
                    if indexPath.section == 0 {
                        self.currentlyViewedList!.toDoItems[indexPath.row].deleteFromDatabase()
                        self.currentlyViewedList!.toDoItems.remove(at: indexPath.row)
                    } else {
                        self.currentlyViewedList!.completedToDoItems[indexPath.row].deleteFromDatabase()
                        self.currentlyViewedList!.completedToDoItems.remove(at: indexPath.row)
                    }
                    
                    self.toDoItemsCollectionView.deleteItems(at: [indexPath])
                    self.progressViewShouldAnimate()
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Close", style: .cancel))
            present(actionSheet, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: section == 0 ? 10 : 10 + toolBar.frame.height, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if currentlyViewedList != nil {
            let string = indexPath.section == 0 ? currentlyViewedList!.toDoItems[indexPath.row].name as NSString : currentlyViewedList!.completedToDoItems[indexPath.row].name as NSString
            let frame = string.boundingRect(with: CGSize(width: collectionView.frame.width - 60 - 20 - 22.5 - 10 - 20, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)], context: nil)
                
            return CGSize(width: collectionView.frame.width - 60, height: frame.height + 40)
        }
        return CGSize(width: collectionView.frame.width - 60, height: 60)
    }
    
}
