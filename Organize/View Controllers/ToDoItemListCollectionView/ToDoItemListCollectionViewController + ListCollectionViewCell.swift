//
//  ListCollectionView + ListCollectionViewCell.swift
//  Organize
//
//  Created by Daniel Valencia on 7/22/21.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: ShouldProgressViewAnimateDelegate?
    
    var hasProgressViewAlreadyAnimated: (Bool, Int)?
    
    var toDoItemList: ToDoItemList? {
        didSet {
            if let toDoItemList = toDoItemList {
                if toDoItemList.toDoItems.isEmpty || toDoItemList.toDoItems.count > 1 {
                    self.totalTasksLabel.text = "\(toDoItemList.toDoItems.count) tasks"
                } else {
                    self.totalTasksLabel.text = "\(toDoItemList.toDoItems.count) task"
                }
                
                self.toDoListNameLabel.text = toDoItemList.name
                                
                let completedItems = toDoItemList.completedToDoItems.count
                let totalItems = toDoItemList.toDoItems.count + toDoItemList.completedToDoItems.count

                if hasProgressViewAlreadyAnimated != nil {
                    if hasProgressViewAlreadyAnimated!.0 {
                        if completedItems != 0 {
                            progressView.setProgress(Float(completedItems) / Float(totalItems), animated: false)
                        }
                    } else {
                        delegate?.progressViewDidAlreadyAnimate(for: (true, hasProgressViewAlreadyAnimated!.1))
                        
                        if completedItems != 0 {
                            performProgressViewAnimation(to: Float(completedItems) / Float(totalItems))
                        }
                    }
                }
            }
        }
    }
    
    private lazy var overallStackView = UIStackView.makeVerticalStackView(with: [totalTasksLabel, toDoListNameLabel, progressView], distribution: .equalSpacing, spacing: 0)
    
    private let totalTasksLabel: UILabel = {
        let label = UILabel.makeSubheadingLabel(with: "")
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private let toDoListNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 22.5)
        label.textAlignment = .left
        label.textColor = .titleLabelFontColor
        return label
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .progressBarColor
        return progressView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        setupSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        delegate = nil
        hasProgressViewAlreadyAnimated = nil
        toDoItemList = nil
        totalTasksLabel.text = ""
        toDoListNameLabel.text = ""
        progressView.progress = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .elevatedBackgroundColor
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.0375
        layer.shadowOffset = CGSize(width: 0, height: 3.75)
    }
    
    private func setupSubviews() {
        addSubview(overallStackView)
        
        overallStackView.anchor(topAnchor: topAnchor, rightAnchor: trailingAnchor, bottomAnchor: bottomAnchor, leftAnchor: leadingAnchor, topPadding: 17.5, rightPadding: 15, bottomPadding: 17.5, leftPadding: 15, height: 0, width: 0)
        
        overallStackView.layoutIfNeeded()
    }
    
    // MARK: - Animations
    
    func updateToDoListNameLabel(with newName: String) {
        UIView.transition(with: toDoListNameLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.toDoListNameLabel.text = newName
        }
    }
    
    private func performProgressViewAnimation(to value: Float) {
        progressView.progress = value
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.progressView.layoutIfNeeded()
        }
    }
    
    func performProgressViewAfterUpdatingToDoItem() {
        if let toDoItemList = self.toDoItemList {
            if toDoItemList.toDoItems.isEmpty || toDoItemList.toDoItems.count > 1 {
                self.totalTasksLabel.text = "\(toDoItemList.toDoItems.count) tasks"
            } else {
                self.totalTasksLabel.text = "\(toDoItemList.toDoItems.count) task"
            }
            
            let totalItems = toDoItemList.toDoItems.count + toDoItemList.completedToDoItems.count
            
            if totalItems != 0 {
                performProgressViewAnimation(to: Float(toDoItemList.completedToDoItems.count) / Float(totalItems))
            } else {
                performProgressViewAnimation(to: 0)
            }
        }
    }
    
}
