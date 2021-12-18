//
//  HomeController + Database.swift
//  Organize
//
//  Created by Daniel Valencia on 7/22/21.
//

import FirebaseAuth
import FirebaseFirestore

extension HomeController: CreateListDelegate {
    
    // MARK: - Fetch all user data from the database
    
    func fetchItemsFromDatabase() {
        if let user = Auth.auth().currentUser {
            
            let toDoListItemsPath = Firestore.firestore().collection("users").document(user.uid).collection("to_do_items")
            
            toDoListItemsPath.order(by: "created", descending: false).getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.totalNumberOfListsToBeFetched = snapshot!.documents.count
                    
                    if !snapshot!.documents.isEmpty {
                        for list in snapshot!.documents {
                            self.createList(with: list, currentPath: toDoListItemsPath)
                        }
                    } else {
                        self.animateSubviews()
                    }
                }
            }
        }
    }
    
    private func createList(with list: QueryDocumentSnapshot, currentPath: CollectionReference) {
        let toDoItemListDecoder = JSONDecoder()
        do {
            var documentData = list.data()
                        
            documentData["created"] = (list.data()["created"] as? Timestamp)?.dateValue().description
                                    
            let jsonData = try JSONSerialization.data(withJSONObject: documentData)
            
            let toDoItemList = try toDoItemListDecoder.decode(ToDoItemList.self, from: jsonData)
            
            toDoItemList.path = currentPath.document(list.documentID)
            
            self.toDoItemLists.append(toDoItemList)
            
            self.fetchItemsFromList(with: toDoItemList)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func fetchItemsFromList(with list: ToDoItemList) {
        let toDoItemDecoder = JSONDecoder()
        
        if let path = list.path {
            path.collection("items").order(by: "created", descending: false).getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        do {
                            var documentData = document.data()
                            
                            documentData["created"] = ((document.data()["created"] as? Timestamp)?.dateValue().description)
                            
                            if documentData["due_date"] as? NSObject != NSNull() {
                                documentData["due_date"] = ((document.data()["due_date"] as? Timestamp)?.dateValue().description)
                            }
                                                        
                            let jsonData = try JSONSerialization.data(withJSONObject: documentData)
                            
                            let toDoItem = try toDoItemDecoder.decode(ToDoItem.self, from: jsonData)
                            
                            if documentData["due_date"] as? NSObject != NSNull() {
                                if let date1 = documentData["due_date"] as? String {
                                    if let date = makeGeneralDateFormatter().date(from: date1) {
                                        toDoItem.dueDate = date
                                    }
                                }
                            }
                            
                            toDoItem.path = path.collection("items").document(document.documentID)
                            
                            if !toDoItem.isCompleted {
                                list.toDoItems.append(toDoItem)
                            } else {
                                list.completedToDoItems.append(toDoItem)
                            }
                        } catch let error {
                            print(String(describing: error))
                        }
                    }
                    self.totalNumberOfListsFetchedSoFar += 1
                    
                    if self.totalNumberOfListsFetchedSoFar == self.totalNumberOfListsToBeFetched {
                        self.didFinishFetchingItemsFromDatabase()
                    }
                }
            }
        }
    }
    
    // MARK: - Updating the UI For the data fetched from the database
    
    private func didFinishFetchingItemsFromDatabase() {
        insertItemsIntoListCollectionView()
        updateToDoItemsCollectionViewWithFirstList()
        insertItemsIntoSlideOutMenuController()
        animateSubviews()
    }
    
    private func insertItemsIntoListCollectionView() {
        listCollectionViewController.toDoItemLists = toDoItemLists
        listCollectionViewController.hasProgressAlreadyAnimatedCache = Array(repeating: false, count: toDoItemLists.count)
        
        var indexPaths = [IndexPath]()
        
        for item in 0...toDoItemLists.count - 1 {
            indexPaths.append(IndexPath(item: item, section: 0))
        }
        
        listCollectionViewController.collectionView.insertItems(at: indexPaths)
    }
    
    private func updateToDoItemsCollectionViewWithFirstList() {
        if let firstList = toDoItemLists.first {
            if !firstList.toDoItems.isEmpty {
                var indexPaths = [IndexPath]()
                for item in 0...firstList.toDoItems.count - 1 {
                    indexPaths.append(IndexPath(item: item, section: 0))
                }
                
                toDoItemsCollectionView.insertItems(at: indexPaths)
            }
            
            if !firstList.completedToDoItems.isEmpty {
                var indexPaths = [IndexPath]()
                for item in 0...firstList.completedToDoItems.count - 1 {
                    indexPaths.append(IndexPath(item: item, section: 1))
                }
                
                toDoItemsCollectionView.insertItems(at: indexPaths)
            }
        }
    }
    
    private func insertItemsIntoSlideOutMenuController() {
        baseController.slideOutMenuController.toDoItemLists = toDoItemLists
        
        var indexPaths = [IndexPath]()
        
        for row in 0...toDoItemLists.count - 1 {
            indexPaths.append(IndexPath(row: row + 1, section: 0))
        }
        
        baseController.slideOutMenuController.tableView.insertRows(at: indexPaths, with: .automatic)
        
        if indexPaths.count > 1 {
            if let row = baseController.slideOutMenuController.tableView.cellForRow(at: indexPaths[0]) {
                row.isSelected = true
                baseController.slideOutMenuController.indexPathOfPreviouslySelectedRow = indexPaths[0]
            }
        }
    }
    
    // MARK: - Updating the lists
    
    func didCreateNewList(list: ToDoItemList) {
        toDoItemLists.append(list)
        listCollectionViewController.toDoItemLists.append(list)
        listCollectionViewController.hasProgressAlreadyAnimatedCache.append(false)
        
        baseController.animateMenu(to: .closed)
        
        currentlyViewedList = toDoItemLists.last
        toDoItemsCollectionView.reloadSections(IndexSet(integer: 0))
        
        let indexPath = IndexPath(item: toDoItemLists.count - 1, section: 0)
        listCollectionViewController.collectionView.insertItems(at: [indexPath])
        listCollectionViewController.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func didDeleteList(deletedList: ToDoItemList) {
        guard let parentController = UIApplication.shared.windows.first?.rootViewController as? BaseController else { return }

        let indexOfDeletedList = self.toDoItemLists.firstIndex(of: deletedList)
        
        if let index = indexOfDeletedList {
            toDoItemLists.remove(at: index)
            listCollectionViewController.toDoItemLists.remove(at: index)
            parentController.slideOutMenuController.toDoItemLists.remove(at: index)
            
            if !toDoItemLists.isEmpty {
                currentlyViewedList = toDoItemLists[0]
                toDoItemsCollectionView.reloadSections(IndexSet(integer: 0))
                
                listCollectionViewController.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                parentController.slideOutMenuController.tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
            }
        }
    }
    
}
