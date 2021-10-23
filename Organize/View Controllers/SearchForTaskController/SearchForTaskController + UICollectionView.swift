//
//  SearchForTaskController + UICollectionView.swift
//  Organize
//
//  Created by Daniel Valencia on 10/23/21.
//

import UIKit

extension SearchForTaskController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ToDoListItemsCollectionViewCell {
            cell.toDoItem = searchResults[indexPath.row]
            cell.delegate = self
            cell.checkMarkView.primaryColorForCell = .primaryColor
            return cell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let string = searchResults[indexPath.row].name
        let frame = string.boundingRect(with: CGSize(width: collectionView.frame.width - 60 - 20 - 22.5 - 10 - 20, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)], context: nil)
        return CGSize(width: collectionView.frame.width - 60, height: frame.height + 40)
    }
    
}
