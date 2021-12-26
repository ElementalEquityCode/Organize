//
//  HomeController + Title.swift
//  Organize
//
//  Created by Daniel Valencia on 10/8/21.
//

import UIKit

class ToDoItemsCollectionViewHeader: UICollectionViewCell {
    
    // MARK: - Properties
    
    let label: UILabel = {
        let label = UILabel.makeSubheadingLabel(with: "")
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        label.textAlignment = .left
        
        addSubview(label)
        
        label.anchor(topAnchor: topAnchor, rightAnchor: trailingAnchor, bottomAnchor: bottomAnchor, leftAnchor: leadingAnchor, topPadding: 0, rightPadding: 30, bottomPadding: 0, leftPadding: 30, height: 0, width: 0)
    }
    
}
