//
//  EditToDoItemController.swift
//  Organize
//
//  Created by Daniel Valencia on 7/29/21.
//

import UIKit
import Firebase

class EditToDoItemController: UIViewController, UITextViewDelegate {
    
    // MARK: - Property
    
    private var indexPath: IndexPath
    
    private unowned let delegate: EditToDoItemDelegate
    
    private var toDoItem: ToDoItem
    
    private let toDoItemTextViewContainerView: UIView = {
        let toDoItemTextViewContainerView = UIView()
        toDoItemTextViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        toDoItemTextViewContainerView.backgroundColor = .elevatedBackgroundColor
        toDoItemTextViewContainerView.layer.cornerRadius = 15
        toDoItemTextViewContainerView.layer.shadowColor = UIColor.black.cgColor
        toDoItemTextViewContainerView.layer.shadowRadius = 10
        toDoItemTextViewContainerView.layer.shadowOpacity = 0.0375
        toDoItemTextViewContainerView.layer.shadowOffset = CGSize(width: 0, height: 3.75)
        return toDoItemTextViewContainerView
    }()
    
    private let setDateAndTimeContainerView: UIView = {
        let setDateAndTimeContainerView = UIView()
        setDateAndTimeContainerView.translatesAutoresizingMaskIntoConstraints = false
        setDateAndTimeContainerView.backgroundColor = .elevatedBackgroundColor
        setDateAndTimeContainerView.layer.cornerRadius = 15
        setDateAndTimeContainerView.layer.shadowColor = UIColor.black.cgColor
        setDateAndTimeContainerView.layer.shadowRadius = 10
        setDateAndTimeContainerView.layer.shadowOpacity = 0.0375
        setDateAndTimeContainerView.layer.shadowOffset = CGSize(width: 0, height: 3.75)
        return setDateAndTimeContainerView
    }()
    
    private var toDoItemTextViewScrollableHeight: NSLayoutConstraint!
    
    private let maxTextViewHeight: CGFloat = 100.00
    
    private let toDoItemTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .titleLabelFontColor
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var dateLabelAndSwitchStackView = UIStackView.makeHorizontalStackView(with: [dateLabel, dateSwitch], distribution: .equalSpacing, spacing: 0)
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "Set date"
        dateLabel.textColor = .titleLabelFontColor
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return dateLabel
    }()
    
    private let dateSwitch: UISwitch = {
        let dateSwitch = UISwitch()
        dateSwitch.onTintColor = .primaryColor
        dateSwitch.translatesAutoresizingMaskIntoConstraints = false
        return dateSwitch
    }()
    
    private let datePickerContainerView: UIView = {
        let datePickerContainerView = UIView()
        datePickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerContainerView.backgroundColor = .elevatedBackgroundColor
        datePickerContainerView.layer.cornerRadius = 15
        return datePickerContainerView
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.isEnabled = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .primaryColor
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    // MARK: - Initialization
    
    init(toDoItem: ToDoItem, delegate: EditToDoItemDelegate, indexPath: IndexPath) {
        self.toDoItem = toDoItem
        self.delegate = delegate
        self.indexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
        
        toDoItemTextView.text = toDoItem.name
        if toDoItem.dueDate != nil {
            dateSwitch.setOn(true, animated: true)
            datePicker.isEnabled = true
            datePicker.date = toDoItem.dueDate!
        }
    }
    
    deinit {
        print("EditToDoItemController deallocated")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondaryBackgroundColor
        setupNavigationItem()
        setupSubviews()
        setupDelegates()
        setupTargets()
    }
    
    private func setupNavigationItem() {
        if navigationController != nil {
            navigationItem.title = "Edit Item"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissThisViewController))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveEdits))
            
            navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController!.navigationBar.shadowImage = UIImage()
        }
    }
    
    private func setupSubviews() {
        toDoItemTextViewContainerView.addSubview(toDoItemTextView)
        setDateAndTimeContainerView.addSubview(dateLabelAndSwitchStackView)
        datePickerContainerView.addSubview(datePicker)
        
        view.addSubview(toDoItemTextViewContainerView)
        view.addSubview(setDateAndTimeContainerView)
        view.addSubview(datePickerContainerView)
        
        toDoItemTextView.anchor(topAnchor: toDoItemTextViewContainerView.topAnchor, rightAnchor: toDoItemTextViewContainerView.trailingAnchor, bottomAnchor: toDoItemTextViewContainerView.bottomAnchor, leftAnchor: toDoItemTextViewContainerView.leadingAnchor, topPadding: 10, rightPadding: 10, bottomPadding: 10, leftPadding: 10, height: 0, width: 0)
        
        dateLabelAndSwitchStackView.anchor(topAnchor: setDateAndTimeContainerView.topAnchor, rightAnchor: setDateAndTimeContainerView.trailingAnchor, bottomAnchor: setDateAndTimeContainerView.bottomAnchor, leftAnchor: setDateAndTimeContainerView.leadingAnchor, topPadding: 10, rightPadding: 10, bottomPadding: 10, leftPadding: 10, height: 0, width: 0)
        
        datePicker.anchor(topAnchor: datePickerContainerView.topAnchor, rightAnchor: datePickerContainerView.trailingAnchor, bottomAnchor: datePickerContainerView.bottomAnchor, leftAnchor: datePickerContainerView.leadingAnchor, topPadding: 10, rightPadding: 10, bottomPadding: 10, leftPadding: 10, height: 0, width: 0)
        
        toDoItemTextViewContainerView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: nil, leftAnchor: view.leadingAnchor, topPadding: navigationController!.navigationBar.frame.height, rightPadding: 30, bottomPadding: 0, leftPadding: 30, height: 0, width: 0)
                
        setDateAndTimeContainerView.anchor(topAnchor: toDoItemTextViewContainerView.bottomAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: nil, leftAnchor: view.leadingAnchor, topPadding: 30, rightPadding: 30, bottomPadding: 0, leftPadding: 30, height: 0, width: 0)
        
        datePickerContainerView.anchor(topAnchor: setDateAndTimeContainerView.bottomAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: nil, leftAnchor: view.leadingAnchor, topPadding: 30, rightPadding: 30, bottomPadding: 0, leftPadding: 30, height: 0, width: 0)
    }
    
    private func setupDelegates() {
        toDoItemTextView.delegate = self
    }
    
    private func setupTargets() {
        dateSwitch.addTarget(self, action: #selector(handleDateSwitchChanged), for: .valueChanged)
    }
    
    // MARK: - UTextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        let numberOfLines = Int(textView.contentSize.height / textView.font!.lineHeight)
        
        if numberOfLines >= 5 {
            if toDoItemTextViewScrollableHeight == nil {
                toDoItemTextViewScrollableHeight = toDoItemTextView.heightAnchor.constraint(equalToConstant: textView.contentSize.height)
                toDoItemTextViewScrollableHeight.isActive = true
                toDoItemTextView.isScrollEnabled = true
            }
        } else if numberOfLines < 5 {
            if toDoItemTextViewScrollableHeight != nil {
                toDoItemTextViewScrollableHeight.constant = textView.contentSize.height
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - Selectors
    
    @objc private func handleDateSwitchChanged() {
        datePicker.isEnabled = dateSwitch.isOn
    }
    
    @objc private func dismissThisViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveEdits() {
        toDoItem.name = toDoItemTextView.text
        
        if toDoItem.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            toDoItem.deleteFromDatabase()
            self.delegate.didDeleteItem(indexPath: self.indexPath)
            self.dismissThisViewController()

        } else {
            var timestamp: Timestamp?
            
            if dateSwitch.isOn {
                timestamp = Timestamp(date: datePicker.date)
                toDoItem.dueDate = datePicker.date
            } else {
                toDoItem.dueDate = nil
            }
            
            toDoItem.updateToDoItem(dueDate: timestamp)
            self.delegate.didEditItem(indexPath: self.indexPath, toDoItem: self.toDoItem)
        }
        self.dismissThisViewController()
    }
    
    // MARK: - Helpers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
