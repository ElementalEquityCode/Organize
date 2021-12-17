//
//  ResetPasswordController.swift
//  Organize
//
//  Created by Daniel Valencia on 7/15/21.
//

import UIKit
import FirebaseAuth

class ResetPasswordController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
        
    private lazy var overallStackView = UIStackView.makeVerticalStackView(with: [loadingIndicatorStackView, titleLabel, subheadingLabel, emailTextField, sendRequestButton, UIView()], distribution: .fill, spacing: 20)
    
    private lazy var loadingIndicatorStackView = UIStackView.makeHorizontalStackView(with: [UIView(), loadingIndicator, UIView()], distribution: .equalSpacing, spacing: 0)
    
    private let loadingIndicator = UIActivityIndicatorView.makeLoginLoadingIndicator()
    
    private let titleLabel = UILabel.makeTitleLabel(with: "Forgot Your Password?")
    
    private let subheadingLabel = UILabel.makeSubheadingLabel(with: "Enter Your Email to Reset it")
    
    private let emailTextField: GeneralTextField = {
        let emailTextField = GeneralTextField(with: "Email", textFieldType: .email)
        return emailTextField
    }()
        
    private let sendRequestButton = UIButton.makeGeneralActionButton(with: "Send Password Reset Email")
    
    // MARK: - Initialization
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        print("ResetPasswordController deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViewController()
        setupSubviews()
        setupButtonTargets()
        setupDelegates()
        setupNotificationCenter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }
    
    private func setupSubviews() {
        view.addSubview(overallStackView)
        
        overallStackView.anchorInCenterOfParent(parentView: view, topPadding: view.frame.height * 0.25, rightPadding: 20, bottomPadding: 40, leftPadding: 20)
    }
    
    private func setupButtonTargets() {
        sendRequestButton.addTarget(self, action: #selector(handleEmailResetRequest), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        emailTextField.delegate = self
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardOpen), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardClose), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField && !emailTextField.text!.isEmpty {
            emailTextField.returnKeyType = .go
            emailTextField.reloadInputViews()
        } else {
            emailTextField.returnKeyType = .default
            emailTextField.reloadInputViews()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == emailTextField && !emailTextField.text!.isEmpty {
            emailTextField.returnKeyType = .go
            emailTextField.reloadInputViews()
        } else {
            emailTextField.returnKeyType = .default
            emailTextField.reloadInputViews()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            textField.resignFirstResponder()
        } else {
            handleEmailResetRequest()
        }
        
        return false
    }
    
    // MARK: - Selectors
    
    @objc private func handleEmailResetRequest() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        loadingIndicator.startAnimating()
        
        if emailTextField.text!.isEmpty {
            present(makeAlertViewController(with: "Error", message: "Fill out all the required fields"), animated: true)
            loadingIndicator.stopAnimating()
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if let error = error {
                self.present(makeAlertViewController(with: "Error", message: error.localizedDescription), animated: true)
            } else {
                self.present(makeAlertViewController(with: "Email Sent", message: "An email was sent to \(self.emailTextField.text!) to resetx your password", completion: {
                    self.dismiss(animated: true)
                }), animated: true)
            }
            
            self.loadingIndicator.stopAnimating()
        }
    }
    
    var keyboardOpenCount = 0
    
    @objc private func handleKeyboardOpen(notification: Notification) {
        if let notificationData = notification.userInfo {
            keyboardOpenCount += 1
            guard let animationDuration = notificationData["UIKeyboardAnimationDurationUserInfoKey"] as? Double else { return }
            guard let keyboardFrame = notificationData["UIKeyboardFrameEndUserInfoKey"] as? CGRect else { return }
            
            let maxY = overallStackView.convert(sendRequestButton.frame, to: self.view).maxY
            
            if keyboardOpenCount == 1 && (maxY > (view.frame.height - keyboardFrame.height)) {
                Organize.performOpenKeyboardAnimation(moving: view, animationDuration, -(maxY - (view.frame.height - keyboardFrame.height)) - 70)
            }
        }
    }
    
    @objc private func handleKeyboardClose(notification: Notification) {
        if let notificationData = notification.userInfo {
            guard let animationDuration = notificationData["UIKeyboardAnimationDurationUserInfoKey"] as? Double else { return }
            
            Organize.performCloseKeyboardAnimation(moving: view, animationDuration)
            keyboardOpenCount = 0
        }
    }
    
    // MARK: - Helpers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
