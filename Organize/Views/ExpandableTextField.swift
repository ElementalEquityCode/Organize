//
//  ExpandableTextField.swift
//  Organize
//
//  Created by Daniel Valencia on 7/16/21.
//

import UIKit

enum KeyboardState {
    case opened
    case closed
}

enum KeyboardInputState {
    case text
    case date
}

class ExpandableTextField: UITextField {
    
    // MARK: - Initialization
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                performEnabledStatusBackgroundColorAnimation(to: .primaryColor)
            } else {
                performEnabledStatusBackgroundColorAnimation(to: .gray)
            }
        }
    }
    
    weak var createItemDelegate: CreateItemDelegate?
    
    var capturedText: String = ""
        
    var capturedDate: Date?
    
    var firstResponderState: KeyboardState = .closed
    
    var inputState: KeyboardInputState = .text {
        didSet {
            switch inputState {
            case .text:
                alpha = 1
                inputView = nil
                reloadInputViews()
                toolBar.setItems([selectDueDateBarButtonItem, createToDoItemBarButtonItem], animated: true)
            case .date:
                alpha = 0
                datePicker.sizeToFit()
                inputView = datePicker
                toolBar.setItems([editToDoItemNameBarButtonItem, createToDoItemBarButtonItem], animated: true)
                reloadInputViews()
            }
        }
    }
    
    var firstResponderWidthAnchor: NSLayoutConstraint!
    
    private let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
    
    private lazy var selectDueDateBarButtonItem: UIBarButtonItem = { [unowned self] in
        let button = UIBarButtonItem(image: UIImage(named: "calendar.badge.plus"), style: .plain, target: self, action: #selector(handleCalendarIconTapped))
        button.tintColor = .titleLabelFontColor
        button.isEnabled = false
        return button
    }()
    
    private lazy var editToDoItemNameBarButtonItem: UIBarButtonItem = { [unowned self] in
        let button = UIBarButtonItem(image: UIImage(named: "doc.plaintext"), style: .plain, target: self, action: #selector(handleBackToTextButtonTapped))
        button.tintColor = .titleLabelFontColor
        return button
    }()
    
    private lazy var createToDoItemBarButtonItem: UIBarButtonItem = { [unowned self] in
        let button = UIBarButtonItem(title: "Create Task", style: .done, target: self, action: #selector(handleFinishSelectingDate))
        button.isEnabled = false
        button.tintColor = .primaryColor
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        
        return bounds.insetBy(dx: 15, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        
        return bounds.insetBy(dx: 15, dy: 0)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupTextField()
        setupSubviews()
        setupTargets()
    }
    
    deinit {
        print("ExpandableTextfield deallocated")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        textColor = .black
        returnKeyType = .done
        textAlignment = .left
        backgroundColor = .primaryColor
        layer.cornerRadius = 30
        textAlignment = .center
        autocorrectionType = .yes
        autocapitalizationType = .sentences
        
        attributedPlaceholder = NSAttributedString(string: "+", attributes: [NSAttributedString.Key.foregroundColor: UIColor.generalActionButtonFontColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .thin), NSAttributedString.Key.baselineOffset: 1])
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        firstResponderWidthAnchor = widthAnchor.constraint(equalToConstant: 60)
        firstResponderWidthAnchor.isActive = true
    }
    
    private func setupSubviews() {
        toolBar.setItems([selectDueDateBarButtonItem, createToDoItemBarButtonItem], animated: true)
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
    }
    
    private func setupTargets() {
        addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidChangeEditing), for: .editingChanged)
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    // MARK: - Selectors
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    @objc private func handleCalendarIconTapped() {
        capturedText = text!
        inputState = .date
    }
    
    @objc private func handleBackToTextButtonTapped() {
        capturedDate = datePicker.date
        inputState = .text
    }
    
    @objc private func textFieldDidBeginEditing() {
        placeholder = ""
        capturedText = ""
        datePicker.date = Date()
        capturedDate = nil
        performAnimation(to: .opened)
    }
    
    @objc private func textFieldDidChangeEditing() {
        capturedText = text!
        selectDueDateBarButtonItem.isEnabled = !text!.trimmingCharacters(in: .whitespaces).isEmpty
        createToDoItemBarButtonItem.isEnabled = !text!.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    @objc private func textFieldDidEndEditing() {
        attributedPlaceholder = NSAttributedString(string: "+", attributes: [NSAttributedString.Key.foregroundColor: UIColor.generalActionButtonFontColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .thin), NSAttributedString.Key.baselineOffset: 1])
        text!.removeAll()
        createToDoItemBarButtonItem.isEnabled = false
        selectDueDateBarButtonItem.isEnabled = false
        performAnimation(to: .closed)
    }
    
    @objc private func handleFinishSelectingDate() {
        if inputState == .date {
            capturedDate = datePicker.date
            resignFirstResponder()
        }
        createItemDelegate?.didCreateItem()
        
        capturedText = ""
        capturedDate = nil
        text = ""
        createToDoItemBarButtonItem.isEnabled = false
        selectDueDateBarButtonItem.isEnabled = false
    }
    
    // MARK: - Animations
    
    private func performEnabledStatusBackgroundColorAnimation(to color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = color
        }
    }
    
    private func performAnimation(to state: KeyboardState) {
        self.firstResponderState = state
        textAlignment = state == .opened ? .left : .center
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.backgroundColor = state == .opened ? .white : .primaryColor
            self.firstResponderWidthAnchor.constant = state == .opened ? UIScreen.main.bounds.width * 0.95 : 60
            self.layoutIfNeeded()
        } completion: { (_) in
            if self.alpha == 0 && !self.isFirstResponder {
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1
                } completion: { (_) in
                    self.inputState = .text
                }
            }
        }
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = state == .opened ? 5 : 30
        animation.toValue = state == .closed ? 30 : 5
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        self.layer.add(animation, forKey: nil)
    }
    
}
