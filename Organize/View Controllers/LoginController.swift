//
//  ViewController.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class LoginController: UIViewController, UserRegistrationDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private let elevatedBackground = UIView.makeElevatedBackground()
    
    private lazy var overallStackView = UIStackView.makeVerticalStackView(with: [loadingIndicatorStackView, titleLabel, subheadingLabel, emailTextField, passwordTextField, loginButton, forgotPasswordButton, UIView(), registerButton], distribution: .fill, spacing: 20)
    
    private lazy var loadingIndicatorStackView = UIStackView.makeHorizontalStackView(with: [UIView(), loadingIndicator, UIView()], distribution: .equalSpacing, spacing: 0)
            
    private let loadingIndicator = UIActivityIndicatorView.makeLoginLoadingIndicator()
    
    private let titleLabel = UILabel.makeTitleLabel(with: "Welcome to Organize")
    
    private let subheadingLabel = UILabel.makeSubheadingLabel(with: "The Minimalist To Do List")
    
    private let emailTextField: GeneralTextField = {
        let textField = GeneralTextField(with: "Email", textFieldType: .email)
        textField.returnKeyType = .continue
        return textField
    }()
    
    private let passwordTextField = GeneralTextField(with: "Password", isSecure: true)
    
    private let loginButton = UIButton.makeGeneralActionButton(with: "Login")
    
    private let forgotPasswordButton = UIButton.makeClearBackgroundGeneralActionButton(with: "Forgot Password?")

    private let registerButton = UIButton.makeClearBackgroundGeneralActionButton(with: "Don't have an account?", attributedString: "Register Now!")

    // MARK: - Initialization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViewController()
        setupSubviews()
        setupButtonTargets()
        setupDelegates()
        startCheckingLoginStatus()
        setupNotificationCenter()
    }
 
    private func setupSubviews() {
        view.addSubview(elevatedBackground)
        elevatedBackground.addSubview(overallStackView)
        
        elevatedBackground.anchor(topAnchor: view.topAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor, leftAnchor: view.leadingAnchor, topPadding: view.frame.height * 0.20, rightPadding: 16, bottomPadding: view.frame.height * 0.20, leftPadding: 16, height: 0, width: 0)
        overallStackView.anchorInCenterOfParent(parentView: elevatedBackground, topPadding: 32, rightPadding: 32, bottomPadding: 32, leftPadding: 32)
    }
    
    private func setupButtonTargets() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(handlePasswordReset), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func startCheckingLoginStatus() {
        checkLoginStatus()
    }
    
    private func checkLoginStatus() {
        if Auth.auth().currentUser != nil {
            loadingIndicator.startAnimating()
            perform(#selector(presentHomeController), with: nil, afterDelay: 1)
        }
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardOpen), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardClose), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UserRegistrationDelegate
    
    func didRegisterUser() {
        presentHomeController()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            if textField.text!.isEmpty {
                textField.resignFirstResponder()
            } else {
                passwordTextField.becomeFirstResponder()
            }
        } else if textField == passwordTextField {
            if textField.text!.isEmpty {
                textField.resignFirstResponder()
            } else {
                handleLogin()
            }
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField && !emailTextField.text!.isEmpty {
            emailTextField.returnKeyType = .continue
            emailTextField.reloadInputViews()
        } else {
            emailTextField.returnKeyType = .default
            emailTextField.reloadInputViews()
        }
        
        if textField == passwordTextField && !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            passwordTextField.returnKeyType = .go
            passwordTextField.reloadInputViews()
        } else {
            passwordTextField.returnKeyType = .default
            passwordTextField.reloadInputViews()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == emailTextField && !emailTextField.text!.isEmpty {
            emailTextField.returnKeyType = .continue
            emailTextField.reloadInputViews()
        } else {
            emailTextField.returnKeyType = .default
            emailTextField.reloadInputViews()
        }
        
        if textField == passwordTextField && !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            passwordTextField.returnKeyType = .go
            passwordTextField.reloadInputViews()
        } else {
            passwordTextField.returnKeyType = .default
            passwordTextField.reloadInputViews()
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleLogin() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

        loadingIndicator.startAnimating()
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            present(makeAlertViewController(with: "Error", message: "Fill out all the required fields"), animated: true)
            loadingIndicator.stopAnimating()
            return
        }
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (_, error) in
            if let error = error {
                self.present(makeAlertViewController(with: "Error", message: error.localizedDescription), animated: true)
            } else {
                self.emailTextField.text!.removeAll()
                self.passwordTextField.text!.removeAll()
                self.presentHomeController()
            }
            
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc private func handleRegister() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        let registerController = RegisterController()
        registerController.userRegistrationDelegate = self
        present(registerController, animated: true)
    }
    
    @objc private func handlePasswordReset() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        present(ResetPasswordController(), animated: true)
    }
    
    var keyboardOpenCount = 0 // Sometimes the handleKeyboardOpen selector is called twice because of the auto-correct toolbar, so after it is called once, that's when I know that's the exact height I want
    
    @objc private func handleKeyboardOpen(notification: Notification) {
        if let notificationData = notification.userInfo {
            keyboardOpenCount += 1
            guard let animationDuration = notificationData["UIKeyboardAnimationDurationUserInfoKey"] as? Double else { return }
            guard let keyboardFrame = notificationData["UIKeyboardFrameEndUserInfoKey"] as? CGRect else { return }
            
            let maxY = overallStackView.convert(registerButton.frame, to: self.view).maxY
            
            if keyboardOpenCount == 1 && (maxY > (view.frame.height - keyboardFrame.height) - 70) {
                performOpenKeyboardAnimation(moving: view, animationDuration, -(maxY - (view.frame.height - keyboardFrame.height)) - 70)
            }
        }
    }
    
    @objc private func handleKeyboardClose(notification: Notification) {
        if let notificationData = notification.userInfo {
            guard let animationDuration = notificationData["UIKeyboardAnimationDurationUserInfoKey"] as? Double else { return }
            
            performCloseKeyboardAnimation(moving: view, animationDuration)
            keyboardOpenCount = 0
        }
    }
    
    // MARK: - Helpers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func presentHomeController() {
        if loadingIndicator.isAnimating {
            loadingIndicator.stopAnimating()
        }
        
        let baseController = BaseController()
        baseController.modalPresentationStyle = .fullScreen
        present(baseController, animated: true)
    }
    
}
