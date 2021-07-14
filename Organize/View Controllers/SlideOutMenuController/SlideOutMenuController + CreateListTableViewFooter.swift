//
//  SlideOutMenuController + CreateListTableViewFooter.swift
//  Organize
//
//  Created by Daniel Valencia on 7/23/21.
//

import UIKit

class CreateListTableViewFooter: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    private let backgroundV: UIView = {
        let backgroundV = UIView()
        backgroundV.translatesAutoresizingMaskIntoConstraints = false
        backgroundV.backgroundColor = .clear
        return backgroundV
    }()
    
    private let backgroundViewContentView: UIView = {
        let backgroundViewContentView = UIView()
        backgroundViewContentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewContentView.backgroundColor = .clear
        return backgroundViewContentView
    }()
    
    private lazy var overallStackView = UIStackView.makeHorizontalStackView(with: [createNewListImageView, createNewListLabel], distribution: .fill, spacing: 10)
    
    private let createNewListImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "folder.badge.plus"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return imageView
    }()
        
    private let createNewListLabel: UILabel = {
        let label = UILabel.makeParagraphLabel(with: "Create new list")
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17.5, weight: .medium)
        return label
    }()
    
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
        backgroundV.addSubview(backgroundViewContentView)
        backgroundViewContentView.addSubview(overallStackView)
        
        backgroundV.anchorInCenterOfParent(parentView: self, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0)
        
        backgroundViewContentView.anchorInCenterOfParent(parentView: backgroundV, topPadding: 20, rightPadding: 40, bottomPadding: 20, leftPadding: 45)
        
        overallStackView.anchorInCenterOfParent(parentView: backgroundViewContentView, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0)
    }
    
}
