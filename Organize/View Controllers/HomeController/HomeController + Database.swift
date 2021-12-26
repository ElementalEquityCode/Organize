//
//  HomeController + Database.swift
//  Organize
//
//  Created by Daniel Valencia on 7/22/21.
//

import FirebaseAuth
import FirebaseStorage
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
    
    func fetchUserProfileImageFromDatabase() {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let data = snapshot!.data() {
                        if let profileImagePath = data["profile_image_url"] as? String {
                            if profileImagePath != "nil" {
                                Storage.storage().reference().child("users").child(user.uid).child("profile_image").getData(maxSize: Int64.max) { (data, error) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        if let image = UIImage(data: data!) {
                                            UIView.transition(with: self.profileButton, duration: 0.5, options: .transitionCrossDissolve) {
                                                self.profileButton.setBackgroundImage(image, for: .normal)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Updating the UI For the data fetched from the database
    
    private func didFinishFetchingItemsFromDatabase() {
        updateToDoItemsCollectionViewWithFirstList()
        insertItemsIntoSlideOutMenuController()
        animateSubviews()
    }
    
    private func updateToDoItemsCollectionViewWithFirstList() {
        if toDoItemLists.first != nil {
            toDoItemsCollectionView.reloadData()
        }
    }
    
    private func insertItemsIntoSlideOutMenuController() {
        baseController.slideOutMenuController.toDoItemLists = toDoItemLists
        
        var indexPaths = [IndexPath]()
        
        for row in 0...toDoItemLists.count - 1 {
            indexPaths.append(IndexPath(row: row + 1, section: 0))
        }
        
        baseController.slideOutMenuController.tableView.insertRows(at: indexPaths, with: .automatic)
        
        if !indexPaths.isEmpty {
            baseController.slideOutMenuController.indexPathOfPreviouslySelectedRow = indexPaths[0]
        }
    }
    
    // MARK: - Updating the lists
    
    func didCreateNewList(list: ToDoItemList) {
        toDoItemLists.append(list)
        
        baseController.animateMenu(to: .closed)
        
        currentlyViewedList = toDoItemLists.last
        toDoItemsCollectionView.reloadSections(IndexSet(integer: 0))
    }
    
    func didDeleteList(deletedList: ToDoItemList) {
        guard let parentController = UIApplication.shared.windows.first?.rootViewController as? BaseController else { return }

        let indexOfDeletedList = self.toDoItemLists.firstIndex(of: deletedList)
        
        if let index = indexOfDeletedList {
            toDoItemLists.remove(at: index)
            parentController.slideOutMenuController.toDoItemLists.remove(at: index)
            
            if !toDoItemLists.isEmpty {
                currentlyViewedList = toDoItemLists[0]
                toDoItemsCollectionView.reloadSections(IndexSet(integer: 0))
                
                parentController.slideOutMenuController.tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
            }
        }
    }
    
}
