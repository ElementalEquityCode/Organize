//
//  HomeViewController.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeController: UIViewController, UITextFieldDelegate, SelectListDelegate, AnimateProgressViewDelegate, EditToDoItemDelegate, CreateItemDelegate {
    
    // MARK: - Properties
    
    var haveItemsBeenFetched = false
    
    var lastOpenedRow: Int?
    
    unowned let baseController: BaseController
    
    lazy var currentlyViewedList: ToDoItemList? = nil {
        didSet {
            if currentlyViewedList != nil {
                listTasksLabel.attributedText = NSAttributedString(string: "Tasks for \(currentlyViewedList!.name)".uppercased(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium), NSAttributedString.Key.kern: 1.5, NSAttributedString.Key.foregroundColor: UIColor.subheadingLabelFontColor])
                addTaskTextField.isEnabled = true
                editListButton.isEnabled = true
            } else {
                addTaskTextField.isEnabled = false
                editListButton.isEnabled = false
            }
        }
    }
    
    var totalNumberOfListsFetchedSoFar = 0
    
    var totalNumberOfListsToBeFetched = 0
    
    var toDoItemLists = [ToDoItemList]() {
        didSet {
            if !toDoItemLists.isEmpty {
                currentlyViewedList = toDoItemLists[0]
            }
        }
    }
        
    lazy var menuSwipeLimit = view.frame.width * 0.6
            
    private lazy var headerIconsNavigationBar = UIStackView.makeHorizontalStackView(with: [slideOutControllerButton, editListButton], distribution: .equalSpacing, spacing: 0)
        
    private let slideOutControllerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "line.horizontal.3"), for: .normal)
        button.imageView!.contentMode = .scaleAspectFill
        button.imageView!.translatesAutoresizingMaskIntoConstraints = false
        button.imageView!.anchorInCenterOfParent(parentView: button, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0)
        button.tintColor = .titleLabelFontColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    
    private let listsLabel: UILabel = {
        let label = UILabel.makeSubheadingLabel(with: "Lists".uppercased())
        label.textAlignment = .left
        return label
    }()
    
    private let editListButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setBackgroundImage(UIImage(named: "pencil.circle"), for: .normal)
        button.imageView!.contentMode = .scaleAspectFill
        button.imageView!.translatesAutoresizingMaskIntoConstraints = false
        button.imageView!.anchorInCenterOfParent(parentView: button, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0)
        button.tintColor = .titleLabelFontColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    
    private var listTasksLabel: UILabel = {
        let label = UILabel.makeSubheadingLabel(with: "")
        label.textAlignment = .left
        return label
    }()
    
    var listCollectionViewController: ToDoItemListCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = ToDoItemListCollectionViewController(collectionViewLayout: layout)
        collectionView.view.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var isEditingCollectionView = false {
        didSet {
            editListButton.isEnabled = !isEditingCollectionView
            performToolBarAnimation()
        }
    }
        
    var toDoItemsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ToDoListItemsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    let addTaskTextField: ExpandableTextField = {
        let expandableTextField = ExpandableTextField()
        expandableTextField.isEnabled = false
        return expandableTextField
    }()
    
    private var addTaskTextFieldBottomAnchor: NSLayoutConstraint!
    
    private var addTaskTextFieldInactiveXAnchor: NSLayoutConstraint!
    
    private var addTaskTextFieldActiveXAnchor: NSLayoutConstraint!
    
    private var addTaskTextFieldHiddenXAnchor: NSLayoutConstraint!

    private var firstResponderGradientLayer = CAGradientLayer()
    
    var menuGradientView = UIView()

    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.tintColor = .black
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
    }()
    
    private var toolBarHiddenAnchor: NSLayoutConstraint!
    
    private var toolBarDisplayedAnchor: NSLayoutConstraint!
    
    // MARK: - Initialization
    
    init(baseController: BaseController) {
        self.baseController = baseController
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        print("HomeController deallocated")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondaryBackgroundColor
        setupSubviews()
        setupToolbar()
        setSubviewsToInvisible()
        setupCollectionView()
        setupFirstResponderGradientLayer()
        setupMenuGradientLayer()
        setupNotificationCenter()
        setupTargets()
        setupDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !haveItemsBeenFetched {
            haveItemsBeenFetched = true
            fetchItemsFromDatabase()
            
            let toolBarItem1 = UIBarButtonItem(image: UIImage(named: "trash"), style: .plain, target: self, action: #selector(handleDeleteSelectedItems))
            toolBarItem1.tintColor = .titleLabelFontColor
            let toolBarItem2 = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCloseToolBar))
            toolBarItem2.tintColor = .titleLabelFontColor
            
            toolBar.items = [toolBarItem1, toolBarItem2]
        }
    }
 
    private func setupSubviews() {
        view.addSubview(headerIconsNavigationBar)
        view.addSubview(listsLabel)
        view.addSubview(toDoItemsCollectionView)
        view.addSubview(listTasksLabel)
        view.addSubview(listCollectionViewController.view)
        view.addSubview(menuGradientView)
        view.addSubview(addTaskTextField)
        
        headerIconsNavigationBar.anchorToTopOfViewController(parentView: view, topPadding: 30, rightPadding: 30, leftPadding: 30, height: 30)
        
        listsLabel.anchor(topAnchor: headerIconsNavigationBar.bottomAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: nil, leftAnchor: view.leadingAnchor, topPadding: 20, rightPadding: 20, bottomPadding: 20, leftPadding: 30, height: 0, width: 0)
                
        toDoItemsCollectionView.anchor(topAnchor: view.centerYAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor, leftAnchor: view.leadingAnchor, topPadding: -view.frame.height * 0.075, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: 0)
        
        listTasksLabel.anchor(topAnchor: nil, rightAnchor: view.trailingAnchor, bottomAnchor: toDoItemsCollectionView.topAnchor, leftAnchor: view.leadingAnchor, topPadding: 20, rightPadding: 30, bottomPadding: 10, leftPadding: 30, height: 0, width: 0)
        
        addChild(listCollectionViewController)
        listCollectionViewController.didMove(toParent: self)
        listCollectionViewController.view.anchor(topAnchor: listsLabel.bottomAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: listTasksLabel.topAnchor, leftAnchor: view.leadingAnchor, topPadding: 20, rightPadding: 0, bottomPadding: 20, leftPadding: 0, height: 0, width: 0)
        
        addTaskTextFieldBottomAnchor = addTaskTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        addTaskTextFieldBottomAnchor.isActive = true
        
        addTaskTextFieldInactiveXAnchor = addTaskTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        addTaskTextFieldInactiveXAnchor.isActive = true
        
        addTaskTextFieldHiddenXAnchor = addTaskTextField.leadingAnchor.constraint(equalTo: view.trailingAnchor)
        
        addTaskTextFieldActiveXAnchor = addTaskTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    }
    
    private func setupToolbar() {
        view.addSubview(toolBar)
        
        toolBarHiddenAnchor = toolBar.topAnchor.constraint(equalTo: view.bottomAnchor)
        toolBarHiddenAnchor.isActive = true

        toolBarDisplayedAnchor = toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    private func setSubviewsToInvisible() {
        slideOutControllerButton.alpha = 0
        editListButton.alpha = 0
        
        listsLabel.alpha = 0
        listCollectionViewController.view.alpha = 0
        
        listTasksLabel.alpha = 0
        toDoItemsCollectionView.alpha = 0
        
        addTaskTextField.alpha = 0
    }
    
    func animateSubviews() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.slideOutControllerButton.alpha = 1
            self.editListButton.alpha = 1
        }
        
        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseOut) {
            self.listsLabel.alpha = 1
            self.listCollectionViewController.view.alpha = 1
        }
        
        UIView.animate(withDuration: 1, delay: 0.4, options: .curveEaseOut) {
            self.listTasksLabel.alpha = 1
            self.toDoItemsCollectionView.alpha = 1
        }
        
        UIView.animate(withDuration: 1, delay: 0.6, options: .curveEaseOut) {
            self.addTaskTextField.alpha = 1
        }
    }
    
    private func setupFirstResponderGradientLayer() {
        firstResponderGradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        firstResponderGradientLayer.locations = [0, 0.4, 1]
        firstResponderGradientLayer.startPoint = CGPoint(x: 1, y: 0)
        firstResponderGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        firstResponderGradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    private func setupMenuGradientLayer() {
        menuGradientView.translatesAutoresizingMaskIntoConstraints = false
        menuGradientView.anchorInCenterOfParent(parentView: view, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0)
        menuGradientView.backgroundColor = UIColor.black
        menuGradientView.alpha = 0
    }
    
    private func setupTargets() {
        slideOutControllerButton.addTarget(baseController, action: #selector(baseController.handleOpenMenu), for: .touchUpInside)
        editListButton.addTarget(self, action: #selector(handleEditList), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMenuCloseTap))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        addTaskTextField.delegate = self
        
        baseController.slideOutMenuController.selectListDelegate = self
        baseController.slideOutMenuController.createListDelegate = self
        
        listCollectionViewController.delegate = self
        
        addTaskTextField.createItemDelegate = self
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardOpen), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardClose), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Selectors
    
    @objc private func handleDeleteSelectedItems() {
        if let selectedIndexPaths = toDoItemsCollectionView.indexPathsForSelectedItems {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            
            if let currentlyViewedList = currentlyViewedList {
                if !currentlyViewedList.toDoItems.isEmpty {
                    let sortedPaths = selectedIndexPaths.sorted(by: {$0.row > $1.row})
                    
                    for index in sortedPaths {
                        currentlyViewedList.toDoItems[index.row].deleteFromDatabase()
                        currentlyViewedList.toDoItems.remove(at: index.row)
                    }
                }
            }
            
            self.toDoItemsCollectionView.deleteItems(at: selectedIndexPaths)
        }
        
        isEditingCollectionView = false
        progressViewShouldAnimate()
    }
    
    @objc private func handleCloseToolBar() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        isEditingCollectionView = false
    }
    
    @objc private func handleKeyboardOpen(notification: Notification) {
        if baseController.menuState == .opened {
            return
        }
        
        if addTaskTextField.isFirstResponder {
            if let notificationData = notification.userInfo {
                guard let animationDuration = notificationData["UIKeyboardAnimationDurationUserInfoKey"] as? Double else { return }
                guard let keyboardFrame = notificationData["UIKeyboardFrameEndUserInfoKey"] as? CGRect else { return }
                            
                let frameGap = view.frame.height - addTaskTextField.frame.maxY
                toDoItemsCollectionView.isUserInteractionEnabled = false
                
                if addTaskTextField.frame.maxY > (view.frame.height - keyboardFrame.height) {
                    performOpenKeyboardAnimation(animationDuration, keyboardFrame.height - frameGap + 50)
                }
            }
        }
    }
    
    @objc private func handleKeyboardClose(notification: Notification) {
        if baseController.menuState == .opened {
            return
        }
        
        if addTaskTextField.isFirstResponder {
            if let notificationData = notification.userInfo {
                guard let animationDuration = notificationData["UIKeyboardAnimationDurationUserInfoKey"] as? Double else { return }
                toDoItemsCollectionView.isUserInteractionEnabled = true
                
                performCloseKeyboardAnimation(animationDuration)
            }
        }
    }
    
    @objc private func handleEditList() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Edit List Name", style: .default, handler: { (_) in
            self.presentEditToDoItemNameActionSheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Select Items", style: .default, handler: { (_) in
            self.isEditingCollectionView = true
        }))
        actionSheet.addAction(UIAlertAction(title: "Delete List", style: .destructive, handler: { (_) in
            self.deleteCurrentlyViewedList()
        }))
        actionSheet.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createToDoItem()
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let gestureRecognizers = view.gestureRecognizers {
            if let panGestureRecognizer = gestureRecognizers.first {
                panGestureRecognizer.isEnabled = false
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let gestureRecognizers = view.gestureRecognizers {
            if let panGestureRecognizer = gestureRecognizers.first {
                panGestureRecognizer.isEnabled = true
            }
        }
    }
    
    // MARK: - SelectListDelegate
    
    func didSelectList(list: ToDoItemList) {
        baseController.animateMenu(to: .closed)
        
        currentlyViewedList = list
        
        toDoItemsCollectionView.reloadSections(IndexSet(integer: 0))
        
        if let index = toDoItemLists.firstIndex(of: list) {
            listCollectionViewController.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - CreateItemDelegate
    
    func didCreateItem() {
        createToDoItem()
    }
    
    // MARK: - AnimateProgressViewDelegate
    
    func progressViewShouldAnimate() {
        if let currentlyViewedList = currentlyViewedList {
            let index = toDoItemLists.firstIndex { (toDoItemList) -> Bool in
                return toDoItemList == currentlyViewedList
            }
            
            if let index = index {
                listCollectionViewController.animateProgressViewForList(at: index)
            }
        }
    }
    
    // MARK: - EditItemProtocol
    
    func didEditItem(row: Int, toDoItem: ToDoItem) {
        if let currentlyViewedList = currentlyViewedList {
            currentlyViewedList.toDoItems[row] = toDoItem
            toDoItemsCollectionView.reloadItems(at: [IndexPath(item: row, section: 0)])
        }
    }
    
    func didDeleteItem(row: Int) {
        if let currentlyViewedList = currentlyViewedList {
            currentlyViewedList.toDoItems.remove(at: row)
            toDoItemsCollectionView.deleteItems(at: [IndexPath(item: row, section: 0)])
        }
    }
    
    // MARK: - Helpers
    
    private func presentEditToDoItemNameActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: "Edit To Do List Name", preferredStyle: .alert)
        actionSheet.addTextField(configurationHandler: nil)
        actionSheet.addAction(UIAlertAction(title: "Save", style: .default, handler: { [unowned self] (_) in
            if let textfield = actionSheet.textFields?[0] {
                if !textfield.text!.isEmpty {
                    if let currentlyViewedList = self.currentlyViewedList {
                        currentlyViewedList.editName(with: textfield.text!)
                        self.listTasksLabel.text = "TASKS FOR \(textfield.text!)"
                        
                        if let indexToUpdate = self.listCollectionViewController.toDoItemLists.firstIndex(of: currentlyViewedList) {
                            let indexPath = IndexPath(item: indexToUpdate, section: 0)
                            if let collectionViewCell = self.listCollectionViewController.collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell {
                                collectionViewCell.updateToDoListNameLabel(with: textfield.text!)
                            }
                            if let tableViewCell = self.baseController.slideOutMenuController.tableView.cellForRow(at: indexPath) as? ListTableViewCell {
                                tableViewCell.updateListNameLabel(with: textfield.text!)
                            }
                        }
                    }
                }
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(actionSheet, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func createToDoItem() {
        let text = addTaskTextField.capturedText.trimmingCharacters(in: .whitespaces)
                
        if !text.isEmpty {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            
            if Auth.auth().currentUser != nil {
                
                let creationDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let uuid = UUID().uuidString
                
                if currentlyViewedList != nil {
                    let path = currentlyViewedList!.path!.collection("items")
                    
                    path.document(uuid).setData(["name": text, "is_completed": false, "created": Timestamp(), "due_date": addTaskTextField.capturedDate ?? NSNull()])
                    
                    currentlyViewedList!.toDoItems.append(ToDoItem(name: text, isCompleted: false, created: creationDate, dueDate: addTaskTextField.capturedDate, path: path.document(uuid)))
                    toDoItemsCollectionView.insertItems(at: [IndexPath(item: currentlyViewedList!.toDoItems.count - 1, section: 0)])
                    toDoItemsCollectionView.scrollToItem(at: IndexPath(item: currentlyViewedList!.toDoItems.count - 1, section: 0), at: .top, animated: true)
                    
                    progressViewShouldAnimate()
                }
            }
        }
    }
    
    private func deleteCurrentlyViewedList() {
        if let currentlyViewedList = currentlyViewedList {
            currentlyViewedList.deleteListFromDatabase { (error1, error2, error3) in
                if let error1 = error1 {
                    print(error1.localizedDescription)
                }
                
                if let error2 = error2 {
                    print(error2.localizedDescription)
                }
                
                if let error3 = error3 {
                    print(error3.localizedDescription)
                }
                
                if let listIndex = self.toDoItemLists.firstIndex(of: self.currentlyViewedList!) {
                    self.toDoItemLists.remove(at: listIndex)
                    self.listCollectionViewController.toDoItemLists.remove(at: listIndex)
                    self.baseController.slideOutMenuController.toDoItemLists.remove(at: listIndex)
                    
                    self.listCollectionViewController.collectionView.reloadSections(IndexSet(integer: 0))
                    self.baseController.slideOutMenuController.tableView.deleteRows(at: [IndexPath(row: listIndex, section: 0)], with: .automatic)
                    
                    if !self.toDoItemLists.isEmpty {
                        self.currentlyViewedList = self.toDoItemLists[0]
                        self.toDoItemsCollectionView.reloadSections(IndexSet(integer: 0))
                        self.listCollectionViewController.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                    } else {
                        self.currentlyViewedList = nil
                        self.listTasksLabel.text = ""
                        self.toDoItemsCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Animations
    
    private func performOpenKeyboardAnimation(_ duration: Double, _ height: CGFloat) {
        addTaskTextFieldBottomAnchor.constant = -height
        addTaskTextFieldInactiveXAnchor.isActive = false
        addTaskTextFieldActiveXAnchor.isActive = true

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            self.menuGradientView.alpha = 0.25
        }

        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        animation.toValue = [UIColor.clear.cgColor, UIColor.paragraphTextColor.withAlphaComponent(0.5).cgColor]
        animation.beginTime = CACurrentMediaTime() + duration
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        firstResponderGradientLayer.add(animation, forKey: nil)
    }
    
    private func performCloseKeyboardAnimation(_ duration: Double) {
        addTaskTextFieldBottomAnchor.constant = -20
        addTaskTextFieldActiveXAnchor.isActive = false
        addTaskTextFieldInactiveXAnchor.isActive = true

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            self.menuGradientView.alpha = 0
        }

        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [UIColor.clear.cgColor, UIColor.paragraphTextColor.withAlphaComponent(0.5).cgColor]
        animation.toValue = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        animation.duration = duration / 4
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        firstResponderGradientLayer.add(animation, forKey: nil)
    }
    
    private func performToolBarAnimation() {
        if isEditingCollectionView {
            toolBarHiddenAnchor.isActive = false
            toolBarDisplayedAnchor.isActive = true
            
            addTaskTextFieldInactiveXAnchor.isActive = false
            addTaskTextFieldHiddenXAnchor.isActive = true
        } else {
            toolBarDisplayedAnchor.isActive = false
            toolBarHiddenAnchor.isActive = true
            
            addTaskTextFieldHiddenXAnchor.isActive = false
            addTaskTextFieldInactiveXAnchor.isActive = true
        }
        
        if let currentlyViewedList = currentlyViewedList {
            var indexPaths = [IndexPath]()
            
            if !currentlyViewedList.toDoItems.isEmpty {
                for row in 0...currentlyViewedList.toDoItems.count - 1 {
                    indexPaths.append(IndexPath(item: row, section: 0))
                }
                toDoItemsCollectionView.reloadItems(at: indexPaths)
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
}
