//
//  UITextFieldFactory.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit

enum TextFieldType {
    case normal
    case email
}

class GeneralTextField: UITextField {
    
    // MARK: - Properties
    
    private let showOrHidePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "eye"), for: .normal)
        button.tintColor = .generalTextFieldTextColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        
        return bounds.insetBy(dx: 10, dy: 0)
    }
        
    // MARK: - Initialization
    
    init(with placeholder: String, textFieldType: TextFieldType = .normal, isSecure: Bool = false) {
        super.init(frame: CGRect.zero)
        
        setupTextField(placeholder, textFieldType, isSecure)
    }
    
    deinit {
        print("GeneralTextField deallocated")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField(_ placeholder: String, _ textFieldType: TextFieldType, _ isSecure: Bool) {
        if textFieldType == .email {
            keyboardType = .emailAddress
        }
        
        backgroundColor = UIColor.textFieldBackgroundColor
        layer.cornerRadius = 5
        autocapitalizationType = .none
        autocorrectionType = .no
        isSecureTextEntry = isSecure
        textColor = UIColor.generalTextFieldTextColor
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor])
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        if isSecure {
            setupRightViewButton()
        }
    }
    
    private func setupRightViewButton() {
        rightViewMode = .whileEditing
        
        let containerView = UIView()
        containerView.addSubview(showOrHidePasswordButton)
        
        showOrHidePasswordButton.anchorInCenterOfParent(parentView: containerView, topPadding: 10, rightPadding: 10, bottomPadding: 10, leftPadding: 10)
        
        rightView = containerView
        
        showOrHidePasswordButton.addTarget(self, action: #selector(handleSetSecureTextEntry), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    @objc private func handleSetSecureTextEntry() {
        isSecureTextEntry = !isSecureTextEntry
    }
    
}
