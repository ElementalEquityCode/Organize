//
//  SlideOutMenuController + ListTableViewCell.swift
//  Organize
//
//  Created by Daniel Valencia on 7/23/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
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
    
    private let listImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "folder"))
        imageView.tintColor = UIColor.white.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return imageView
    }()
    
    let listNameLabel: UILabel = {
        let label = UILabel.makeParagraphLabel(with: "")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .slideOutMenuControllerPrimaryTextColor
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
    }
    
    private func setupSubviews() {
        self.backgroundView = backgroundV
        
        addSubview(backgroundV)
        backgroundV.addSubview(backgroundViewContentView)
        backgroundViewContentView.addSubview(listImageView)
        backgroundViewContentView.addSubview(listNameLabel)
        
        backgroundV.anchorInCenterOfParent(parentView: self, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0)
        
        backgroundViewContentView.anchorInCenterOfParent(parentView: backgroundV, topPadding: 20, rightPadding: 40, bottomPadding: 20, leftPadding: 45)
        
        listImageView.centerYAnchor.constraint(equalTo: backgroundViewContentView.centerYAnchor).isActive = true
        listImageView.leadingAnchor.constraint(equalTo: backgroundViewContentView.leadingAnchor).isActive = true
        
        listNameLabel.anchor(topAnchor: backgroundViewContentView.topAnchor, rightAnchor: backgroundViewContentView.trailingAnchor, bottomAnchor: backgroundViewContentView.bottomAnchor, leftAnchor: listImageView.trailingAnchor, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 10, height: 0, width: 0)
    }
    
    // MARK: - Animations
    
    func updateListNameLabel(with newName: String) {
        UIView.transition(with: listNameLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.listNameLabel.text = newName
        }
    }
    
}
