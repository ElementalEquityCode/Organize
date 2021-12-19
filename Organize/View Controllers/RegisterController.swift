//
//  RegisterController.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class RegisterController: UIViewController, UITextFieldDelegate, PHPickerViewControllerDelegate {
    
    // MARK: - Properties
    
    private let elevatedBackground = UIView.makeElevatedBackground()
        
    weak var userRegistrationDelegate: UserRegistrationDelegate?
    
    var didSetProfileImage = false
    
    private lazy var overallStackView = UIStackView.makeVerticalStackView(with: [loadingIndicatorStackView, profileImageViewStackView, titleLabel, subheadingLabel, emailTextField, passwordTextField, confirmPasswordTextField, UIView(), createAccountButton], distribution: .fill, spacing: 20)
    
    private lazy var loadingIndicatorStackView = UIStackView.makeHorizontalStackView(with: [UIView(), loadingIndicator, UIView()], distribution: .equalSpacing, spacing: 0)
    
    private let loadingIndicator = UIActivityIndicatorView.makeLoginLoadingIndicator()
    
    private let titleLabel = UILabel.makeTitleLabel(with: "Create Account")
    
    private let subheadingLabel = UILabel.makeSubheadingLabel(with: "Get Started for Free Today")
    
    private lazy var profileImageViewStackView = UIStackView.makeHorizontalStackView(with: [UIView(), profileImageView, UIView()], distribution: .equalSpacing, spacing: 0)
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "person.crop.circle"))
        imageView.tintColor = .paragraphTextColor
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = (UIScreen.main.bounds.width * 0.3) / (2)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let emailTextField = GeneralTextField(with: "Email", textFieldType: .email)
    
    private let passwordTextField = GeneralTextField(with: "Password", isSecure: true)
    
    private let confirmPasswordTextField = GeneralTextField(with: "Confirm Password", isSecure: true)

    private let createAccountButton = UIButton.makeGeneralActionButton(with: "Register")
    
    // MARK: - Initialization
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        print("RegisterController deallocated")
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
        view.addSubview(elevatedBackground)
        elevatedBackground.addSubview(overallStackView)
        
        elevatedBackground.anchor(topAnchor: view.topAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor, leftAnchor: view.leadingAnchor, topPadding: view.frame.height * 0.10, rightPadding: 16, bottomPadding: view.frame.height * 0.10, leftPadding: 16, height: 0, width: 0)
        overallStackView.anchorInCenterOfParent(parentView: elevatedBackground, topPadding: 32, rightPadding: 32, bottomPadding: 32, leftPadding: 32)
    }
    
    private func setupButtonTargets() {
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPHPickerViewController)))
        createAccountButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardOpen), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardClose), name: UIResponder.keyboardWillHideNotification, object: nil)
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
                confirmPasswordTextField.becomeFirstResponder()
            }
        } else if textField == confirmPasswordTextField {
            if textField.text!.isEmpty {
                textField.resignFirstResponder()
            } else {
                handleRegister()
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
            passwordTextField.returnKeyType = .continue
            passwordTextField.reloadInputViews()
        } else {
            passwordTextField.returnKeyType = .default
            passwordTextField.reloadInputViews()
        }
        
        if textField == confirmPasswordTextField && !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !confirmPasswordTextField.text!.isEmpty {
            confirmPasswordTextField.returnKeyType = .go
            confirmPasswordTextField.reloadInputViews()
        } else {
            confirmPasswordTextField.returnKeyType = .default
            confirmPasswordTextField.reloadInputViews()
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
            passwordTextField.returnKeyType = .continue
            passwordTextField.reloadInputViews()
        } else {
            passwordTextField.returnKeyType = .default
            passwordTextField.reloadInputViews()
        }
        
        if textField == confirmPasswordTextField && !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !confirmPasswordTextField.text!.isEmpty {
            confirmPasswordTextField.returnKeyType = .go
            confirmPasswordTextField.reloadInputViews()
        } else {
            confirmPasswordTextField.returnKeyType = .default
            confirmPasswordTextField.reloadInputViews()
        }
    }
    
    // MARK: - PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self.present(makeAlertViewController(with: "Error", message: "Image could not be loaded in."), animated: true)
                        }
                    } else {
                        if let profileImage = image as? UIImage {
                            self.didSetProfileImage = true
                            DispatchQueue.main.async {
                                UIView.transition(with: self.profileImageView, duration: 0.5, options: .transitionCrossDissolve) {
                                    self.profileImageView.image = profileImage.withRenderingMode(.alwaysOriginal)
                                }
                            }
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    
    @objc private func presentPHPickerViewController() {
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1
        
        let viewController = PHPickerViewController(configuration: configuration)
        viewController.delegate = self
        
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    self.present(viewController, animated: true)
                } else {
                    self.present(makeAlertViewController(with: "Error", message: "To set a profile image, access to your media library is required"), animated: true)
                }
            }
        }
    }
    
    @objc private func handleRegister() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        loadingIndicator.startAnimating()
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty || confirmPasswordTextField.text!.isEmpty {
            present(makeAlertViewController(with: "Error", message: "Fill out all the required fields"), animated: true)
            loadingIndicator.stopAnimating()
            return
        }
        
        if  passwordTextField.text! != confirmPasswordTextField.text! {
            present(makeAlertViewController(with: "Error", message: "Passwords do not match"), animated: true)
            loadingIndicator.stopAnimating()
            return
        }
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if let error = error {
                self.present(makeAlertViewController(with: "Error", message: error.localizedDescription), animated: true)
            } else {
                guard let result = result else { return }
                
                let homeListUUID = UUID().uuidString
                
                let storageLocation = Storage.storage().reference().child("users").child(result.user.uid).child("profile_image")
                
                if self.didSetProfileImage {
                    if let imageData = self.profileImageView.image!.jpegData(compressionQuality: 0.8) {
                        storageLocation.putData(imageData)
                       
                        Firestore.firestore().collection("users").document(result.user.uid).setData(["email": result.user.email as Any, "profile_image_url": storageLocation.fullPath])
                    }
                } else {
                    Firestore.firestore().collection("users").document(result.user.uid).setData(["email": result.user.email as Any, "profile_image_url": "nil"])
                }
                
                let date = Date()
                                
                Firestore.firestore().collection("users").document(result.user.uid).collection("to_do_items").document(homeListUUID).setData(["list_name": "Home", "created": date])

                Firestore.firestore().collection("users").document(result.user.uid).collection("to_do_items").document(homeListUUID).collection("items").document(UUID().uuidString).setData(["name": "First Item", "is_completed": false, "created": date, "due_date": NSNull()])
                
                self.dismiss(animated: true) {
                    self.userRegistrationDelegate?.didRegisterUser()
                }
            }
            
            self.loadingIndicator.stopAnimating()
        }
    }
    
    var count = 0
    
    @objc private func handleKeyboardOpen(notification: Notification) {
        if let notificationData = notification.userInfo {
            count += 1
            guard let animationDuration = notificationData["UIKeyboardAnimationDurationUserInfoKey"] as? Double else { return }
            guard let keyboardFrame = notificationData["UIKeyboardFrameEndUserInfoKey"] as? CGRect else { return }
            
            let maxY = overallStackView.convert(createAccountButton.frame, to: self.view).maxY
            
            if count == 1 && maxY > (view.frame.height - keyboardFrame.height) {
                Organize.performOpenKeyboardAnimation(moving: view, animationDuration, -(maxY - (view.frame.height - keyboardFrame.height)) - 70)
            }
        }
    }
    
    @objc private func handleKeyboardClose(notification: Notification) {
        if let notificationData = notification.userInfo {
            guard let animationDuration = notificationData["UIKeyboardAnimationDurationUserInfoKey"] as? Double else { return }
            
            performCloseKeyboardAnimation(moving: view, animationDuration)
            count = 0
        }
    }
    
    // MARK: - Helpers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
