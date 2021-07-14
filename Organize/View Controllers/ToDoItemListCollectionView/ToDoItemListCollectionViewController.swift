//
//  ListCollectionView.swift
//  Organize
//
//  Created by Daniel Valencia on 7/21/21.
//

import UIKit

class ToDoItemListCollectionViewController: UICollectionViewController, ShouldProgressViewAnimateDelegate {
    
    // MARK: - Properties
    
    weak var delegate: SelectListDelegate?
    
    var toDoItemLists = [ToDoItemList]()
    
    var hasProgressAlreadyAnimatedCache = [Bool]()
    
    // MARK: - Initialization
    
    deinit {
        print("ToDoItemListCollectionViewController deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    // MARK: - ShouldProgressViewAnimateDelegate
    
    func progressViewDidAlreadyAnimate(for row: (Bool, Int)) {
        hasProgressAlreadyAnimatedCache[row.1] = row.0
    }
    
    // MARK: - Helpers
    
    func animateProgressViewForList(at index: Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ListCollectionViewCell {
            cell.performProgressViewAfterUpdatingToDoItem()
        }
    }
    
}
