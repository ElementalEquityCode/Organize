//
//  SlideOutMenuController + ProfileTableViewHeader.swift
//  Organize
//
//  Created by Daniel Valencia on 7/23/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class ProfileTableViewHeader: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    private let backgroundV: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundViewContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var overallStackView = UIStackView.makeVerticalStackView(with: [profileImageViewStackView, emailLabel, logoutImageViewAndLogoutButtonStackView], distribution: .equalSpacing, spacing: 20)
    
    private lazy var profileImageViewStackView = UIStackView.makeHorizontalStackView(with: [profileImageView, UIView()], distribution: .fill, spacing: 0)
        
    let closeMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        button.layer.cornerRadius = 25
        button.setImage(UIImage(named: "chevron.backward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 1, bottom: 5, right: 5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "person.crop.circle"))
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel.makeNameLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var logoutImageViewAndLogoutButtonStackView = UIStackView.makeHorizontalStackView(with: [logoutImageView, logoutButton], distribution: .fill, spacing: 10)
    
    private let logoutImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "power"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return imageView
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton.makeClearBackgroundGeneralActionButton(with: "Log Out")
        button.setAttributedTitle(NSAttributedString(string: "Sign Out", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.5, weight: .regular)]), for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let borderView = UIView.makeBorderView()
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        fetchUserProfileImageFromDatabase()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(backgroundV)
        backgroundV.addSubview(backgroundViewContentView)
        
        backgroundV.anchorInCenterOfParent(parentView: self, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0)
        
        backgroundViewContentView.anchorInCenterOfParent(parentView: backgroundV, topPadding: 20, rightPadding: 40, bottomPadding: 20, leftPadding: 45)
        
        backgroundViewContentView.addSubview(closeMenuButton)
        backgroundViewContentView.addSubview(overallStackView)
        
        closeMenuButton.anchor(topAnchor: backgroundViewContentView.topAnchor, rightAnchor: backgroundViewContentView.trailingAnchor, bottomAnchor: nil, leftAnchor: nil, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: 0)
        
        overallStackView.anchor(topAnchor: closeMenuButton.centerYAnchor, rightAnchor: closeMenuButton.leadingAnchor, bottomAnchor: backgroundViewContentView.bottomAnchor, leftAnchor: backgroundViewContentView.leadingAnchor, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: 0)
    }
    
    private func fetchUserProfileImageFromDatabase() {
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
                                            UIView.transition(with: self.profileImageView, duration: 0.5, options: .transitionCrossDissolve) {
                                                self.profileImageView.image = image
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
    
}
