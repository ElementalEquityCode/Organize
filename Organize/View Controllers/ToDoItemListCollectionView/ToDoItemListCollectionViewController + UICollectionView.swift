//
//  ListCollectionView + UICollectionView.swift
//  Organize
//
//  Created by Daniel Valencia on 7/22/21.
//

import UIKit

extension ToDoItemListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        view.layer.masksToBounds = false
        collectionView.layer.masksToBounds = false
        view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toDoItemLists.isEmpty ? 0 : toDoItemLists.count
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ListCollectionViewCell {
            if !toDoItemLists.isEmpty {
                cell.delegate = self
                cell.hasProgressViewAlreadyAnimated = (hasProgressAlreadyAnimatedCache[indexPath.row], indexPath.row)
                cell.toDoItemList = toDoItemLists[indexPath.row]
                
                cell.progressView.progressTintColor = indexPath.row % 2 == 0 ? .primaryColor : .secondaryColor
            }
            
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.didSelectList(list: toDoItemLists[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.55, height: view.frame.height)
    }
    
}
