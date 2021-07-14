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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if toDoItemLists.isEmpty {
            return 0
        } else {
            if currentlyViewedList != nil {
                return currentlyViewedList!.toDoItems.count
            } else {
                return 0
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ToDoListItemsCollectionViewCell {
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
                cell.toDoItem = currentlyViewedList!.toDoItems[indexPath.row]
                cell.animateProgressViewDelegate = self
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
                    let toDoItem = self.currentlyViewedList!.toDoItems[indexPath.row]
                    let viewController = UINavigationController(rootViewController: EditToDoItemController(toDoItem: toDoItem, delegate: self, row: indexPath.row))
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete Item", style: .destructive, handler: { (_) in
                if self.currentlyViewedList != nil {
                    self.currentlyViewedList!.toDoItems[indexPath.row].deleteFromDatabase()
                    self.currentlyViewedList!.toDoItems.remove(at: indexPath.row)
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
        return UIEdgeInsets(top: 10, left: 0, bottom: toolBar.frame.height + 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let currentViewedList = currentlyViewedList {
            if !currentViewedList.toDoItems.isEmpty {
                let string = currentlyViewedList!.toDoItems[indexPath.row].name as NSString
                let frame = string.boundingRect(with: CGSize(width: collectionView.frame.width - 60 - 20 - 22.5 - 10 - 20, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)], context: nil)
                return CGSize(width: collectionView.frame.width - 60, height: frame.height + 40)
            }
        }
        return CGSize(width: collectionView.frame.width - 60, height: 60)
    }
    
}
