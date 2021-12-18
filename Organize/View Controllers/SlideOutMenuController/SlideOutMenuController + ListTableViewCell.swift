//
//  SlideOutMenuController + ListTableViewCell.swift
//  Organize
//
//  Created by Daniel Valencia on 7/23/21.
//

import UIKit

class ListLabelCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let backgroundV: UIView = {
        let backgroundV = UIView()
        backgroundV.translatesAutoresizingMaskIntoConstraints = false
        backgroundV.backgroundColor = .clear
        backgroundV.layer.cornerRadius = 8
        return backgroundV
    }()
    
    private let backgroundViewContentView: UIView = {
        let backgroundViewContentView = UIView()
        backgroundViewContentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewContentView.backgroundColor = .clear
        return backgroundViewContentView
    }()
  
    let listsLabel: UILabel = {
        let label = UILabel.makeParagraphLabel(with: "LISTS")
        label.backgroundColor = .clear
        label.textColor = UIColor(red: 107/255, green: 114/255, blue: 128/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
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
    
    override func prepareForReuse() {
        listsLabel.text = ""
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupSubviews() {
        addSubview(listsLabel)
        
        listsLabel.anchor(topAnchor: topAnchor, rightAnchor: trailingAnchor, bottomAnchor: bottomAnchor, leftAnchor: leadingAnchor, topPadding: 40, rightPadding: 0, bottomPadding: 10, leftPadding: 40, height: 0, width: 0)
    }
    
    // MARK: - Animations
    
    func updateListNameLabel(with newName: String) {
        UIView.transition(with: listsLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.listsLabel.text = newName
        }
    }
   
}

class ListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            setSelectedBackgroundColor(to: isSelected)
        }
    }
    
    private let backgroundV: UIView = {
        let backgroundV = UIView()
        backgroundV.translatesAutoresizingMaskIntoConstraints = false
        backgroundV.backgroundColor = .clear
        backgroundV.layer.cornerRadius = 8
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
        imageView.tintColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return imageView
    }()
    
    let listNameLabel: UILabel = {
        let label = UILabel.makeParagraphLabel(with: "")
        label.textColor = UIColor(red: 178/255, green: 184/255, blue: 206/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 17.5, weight: .semibold)
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
    
    override func prepareForReuse() {
        listNameLabel.text = ""
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
        
        backgroundV.anchorInCenterOfParent(parentView: self, topPadding: 4, rightPadding: 16, bottomPadding: 4, leftPadding: 16)
        
        backgroundViewContentView.anchorInCenterOfParent(parentView: backgroundV, topPadding: 20, rightPadding: 24, bottomPadding: 20, leftPadding: 24)
        
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
    
    private func setSelectedBackgroundColor(to active: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.backgroundV.backgroundColor = active ? .white.withAlphaComponent(0.08) : .clear
            self.listNameLabel.textColor = active ? UIColor.secondaryColor : UIColor(red: 178/255, green: 184/255, blue: 206/255, alpha: 1)
            self.listImageView.tintColor = active ? UIColor.secondaryColor : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)
        }
        UIView.transition(with: self.listNameLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.listNameLabel.font = active ? UIFont.systemFont(ofSize: 17.5, weight: .bold) : UIFont.systemFont(ofSize: 17.5, weight: .semibold)
        }
    }
    
}
