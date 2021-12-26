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
        if searchResults.isEmpty {
            return 0
        } else {
            return searchResults[section].count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchResultsListNames.count
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ToDoListItemsCollectionViewCell {
            cell.toDoItem = searchResults[indexPath.section][indexPath.row]
            cell.delegate = self
            return cell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? ToDoItemsCollectionViewHeader {
            header.label.attributedText = NSAttributedString(string: searchResultsListNames[indexPath.section], attributes: [NSAttributedString.Key.font: UIFont.preferredFont(for: .subheadline, weight: .medium), NSAttributedString.Key.kern: 1.25, NSAttributedString.Key.foregroundColor: UIColor.subheadingLabelFontColor])
            return header
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let string = searchResults[indexPath.section][indexPath.row].name
        let frame = string.boundingRect(with: CGSize(width: collectionView.frame.width - 60 - 20 - 22.5 - 10 - 20, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)], context: nil)
        return CGSize(width: collectionView.frame.width - 60, height: frame.height + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }

}
