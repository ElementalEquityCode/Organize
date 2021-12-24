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
        button.tintColor = .generalTextFieldFontColor
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
        setupTargets()
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
        
        font = UIFont.systemFont(ofSize: font!.pointSize, weight: .medium)
        backgroundColor = UIColor.elevatedBackgroundColor
        layer.cornerRadius = 8
        autocapitalizationType = .none
        autocorrectionType = .no
        isSecureTextEntry = isSecure
        textColor = UIColor.generalTextFieldFontColor
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.generalTextFieldBorderColor.cgColor
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderTextColor])
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        if isSecure {
            setupRightViewButton()
        }
    }
    
    private func setupTargets() {
        addTarget(self, action: #selector(textFieldDidOpen), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidClose), for: .editingDidEnd)
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
    
    @objc private func textFieldDidOpen() {
        let animation1 = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
        animation1.fromValue = UIColor.white.cgColor
        animation1.toValue = UIColor.primaryColor.cgColor
        animation1.duration = 0.1
        animation1.fillMode = .forwards
        animation1.isRemovedOnCompletion = false
        layer.add(animation1, forKey: nil)
        
        let animation2 = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
        animation2.fromValue = 0.5
        animation2.toValue = 1.5
        animation2.duration = 0.1
        animation2.fillMode = .forwards
        animation2.isRemovedOnCompletion = false
        layer.add(animation2, forKey: nil)
    }
    
    @objc private func textFieldDidClose() {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
        animation.fromValue = UIColor.primaryColor.cgColor
        animation.toValue = UIColor.white
        animation.duration = 0.1
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: nil)
        
        let animation2 = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
        animation2.fromValue = 1.5
        animation2.toValue = 0.5
        animation2.duration = 0.1
        animation2.fillMode = .forwards
        animation2.isRemovedOnCompletion = false
        layer.add(animation2, forKey: nil)
        layer.add(animation, forKey: nil)
    }
}
