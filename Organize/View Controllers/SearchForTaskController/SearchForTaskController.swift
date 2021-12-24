//
//  SearchForTaskController.swift
//  Organize
//
//  Created by Daniel Valencia on 10/23/21.
//

import UIKit

class SearchForTaskController: UIViewController, UITextFieldDelegate, CompletionStatusDelegate {
    
    // MARK: - Properties
    
    weak var delegate: CompletionStatusFromSearchControllerDelegate?
    var toDoItemLists = [ToDoItemList]()
    var searchResults = [ToDoItem]()
    
    private let searchBar = GeneralTextField(with: "Search...", textFieldType: .normal, isSecure: false)
    
    let searchResultsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ToDoListItemsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackgroundColor
        setupNavigationController()
        setupSubviews()
        setupDelegates()
        setupCollectionView()
    }
    
    deinit {
        print("SearchForTaskController deallocated")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
    
    private func setupNavigationController() {
        if navigationController != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.backward"), style: .plain, target: self, action: #selector(dismissThisViewController))
            navigationItem.title = "Search"
            navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController!.navigationBar.shadowImage = UIImage()
        }
    }
    
    private func setupSubviews() {
        view.addSubview(searchBar)
        view.addSubview(searchResultsCollectionView)
        
        searchBar.anchorToTopOfViewController(parentView: view, topPadding: 30, rightPadding: 30, leftPadding: 30, height: 60)
        
        searchResultsCollectionView.anchor(topAnchor: searchBar.bottomAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor, leftAnchor: view.leadingAnchor, topPadding: 20, rightPadding: 0, bottomPadding: 30, leftPadding: 0, height: 0, width: 0)
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
    }
    
    // MARK: - UITextFieldDelegate

    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchResults.removeAll()
        
        if !textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            toDoItemLists.forEach { (list) in
                list.toDoItems.forEach { (uncompletedItem) in
                    if uncompletedItem.name.lowercased().contains(textField.text!.lowercased()) {
                        searchResults.append(uncompletedItem)
                    }
                }
                list.completedToDoItems.forEach { (completedItem) in
                    if completedItem.name.lowercased().contains(textField.text!.lowercased()) {
                        searchResults.append(completedItem)
                    }
                }
            }
        } else {
            searchResults.removeAll()
        }
        
        searchResultsCollectionView.reloadData()
    }
    
    // MARK: - Selectors
    
    @objc private func dismissThisViewController() {
        dismiss(animated: true)
    }
    
    // MARK: - CompletionStatusDelegate
    
    func didCompleteTask(task: ToDoItem) {
        let currentlyViewedList = getCurrentlyViewedListForCheckedItem(task: task)
        
        if let currentlyViewedList = currentlyViewedList {
            if task.isCompleted {
                if let index = currentlyViewedList.toDoItems.firstIndex(where: { (toDoItem) -> Bool in
                    return toDoItem === task
                }) {
                    currentlyViewedList.toDoItems.remove(at: index)
                                        
                    currentlyViewedList.completedToDoItems.insert(task, at: getToDoItemListInsertionPositionOrderedByDate(for: task, list: currentlyViewedList.completedToDoItems))
                }
            } else {
                if let index = currentlyViewedList.completedToDoItems.firstIndex(where: { (toDoItem) -> Bool in
                    return toDoItem === task
                }) {
                    currentlyViewedList.completedToDoItems.remove(at: index)
                                        
                    currentlyViewedList.toDoItems.insert(task, at: getToDoItemListInsertionPositionOrderedByDate(for: task, list: currentlyViewedList.toDoItems))
                }
            }
            
            delegate?.didChangeTaskCompletionStatus()
        }
    }
    
    // MARK: - Helpers
    
    private func getCurrentlyViewedListForCheckedItem(task: ToDoItem) -> ToDoItemList? {
        var currentlyViewedList: ToDoItemList?
        
        toDoItemLists.forEach { (list) in
            list.toDoItems.forEach { (toDoItem) in
                if toDoItem == task {
                    currentlyViewedList = list
                }
            }
            
            list.completedToDoItems.forEach { (toDoItem) in
                if toDoItem == task {
                    currentlyViewedList = list
                }
            }
        }
        
        return currentlyViewedList
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
}
