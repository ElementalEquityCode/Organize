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
    
    private lazy var emailLabelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.04)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailLabel)
        
        emailLabel.anchor(topAnchor: view.topAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor, leftAnchor: view.leadingAnchor, topPadding: 11, rightPadding: 24, bottomPadding: 11, leftPadding: 24, height: 0, width: 0)
        
        return view
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel.makeNameLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
        
    private let horizontalBorderView = UIView.makeHorizontalBorderView()
            
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(backgroundV)
        backgroundV.addSubview(horizontalBorderView)
        backgroundV.addSubview(backgroundViewContentView)
        
        backgroundV.anchorInCenterOfParent(parentView: self, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0)
        
        horizontalBorderView.anchor(topAnchor: nil, rightAnchor: backgroundV.trailingAnchor, bottomAnchor: backgroundV.bottomAnchor, leftAnchor: backgroundV.leadingAnchor, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: 0)
        
        backgroundViewContentView.anchor(topAnchor: backgroundV.topAnchor, rightAnchor: backgroundV.trailingAnchor, bottomAnchor: horizontalBorderView.topAnchor, leftAnchor: backgroundV.leadingAnchor, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: 0)
        
        backgroundViewContentView.addSubview(emailLabelContainerView)
                
        emailLabelContainerView.anchor(topAnchor: backgroundViewContentView.topAnchor, rightAnchor: backgroundViewContentView.trailingAnchor, bottomAnchor: backgroundViewContentView.bottomAnchor, leftAnchor: backgroundViewContentView.leadingAnchor, topPadding: 16, rightPadding: 24, bottomPadding: 16, leftPadding: 24, height: 0, width: 0)
    }
    
}
