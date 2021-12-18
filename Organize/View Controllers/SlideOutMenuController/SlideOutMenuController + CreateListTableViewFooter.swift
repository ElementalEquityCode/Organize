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
    
    let createNewListButton: UIButton = {
        let button = UIButton.makeGeneralActionButton(with: "Create new list")
        button.backgroundColor = UIColor.secondaryColor
        return button
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
        backgroundV.addSubview(createNewListButton)
        
        backgroundV.anchorInCenterOfParent(parentView: self, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0)
        
        horizontalBorderView.anchor(topAnchor: backgroundV.topAnchor, rightAnchor: backgroundV.trailingAnchor, bottomAnchor: nil, leftAnchor: backgroundV.leadingAnchor, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: 0)
        
        createNewListButton.anchor(topAnchor: backgroundV.topAnchor, rightAnchor: backgroundV.trailingAnchor, bottomAnchor: backgroundV.bottomAnchor, leftAnchor: backgroundV.leadingAnchor, topPadding: 16, rightPadding: 24, bottomPadding: 16, leftPadding: 24, height: 0, width: 0)
    }
    
}
