//
//  HomeController + ToDoListItemsCollectionViewCell.swift
//  Organize
//
//  Created by Daniel Valencia on 7/22/21.
//

import UIKit

class ToDoListItemsCollectionViewCell: UICollectionViewCell, CheckMarkViewDelegate {
    
    // MARK: - Properties
    
    weak var delegate: CompletionStatusDelegate?
    
    var isSelectable = false
    
    override var isSelected: Bool {
        didSet {
            if isSelectable {
                if self.isSelected {
                    animateBackgroundColor(to: UIColor.primaryColor.withAlphaComponent(0.3))
                } else {
                    animateBackgroundColor(to: UIColor.elevatedBackgroundColor)
                }
            }
        }
    }
        
    weak var toDoItem: ToDoItem? {
        didSet {
            guard let item = toDoItem else { return }
            
            taskNameLabel.text = item.name
            
            if item.dueDate != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/YYYY"
                dueDateLabel.text = dateFormatter.string(from: item.dueDate!)
                
                let comparison = item.dueDate!.compare(Date())
                
                if comparison.rawValue < 0 {
                    dueDateLabel.textColor = .systemRed
                } else {
                    dueDateLabel.textColor = .systemGray
                }
            } else {
                dueDateLabel.removeFromSuperview()
            }
            
            checkMarkView.isChecked = item.isCompleted
            performTaskLabelAnimation(with: item.isCompleted)
        }
    }
    
    let checkMarkView = CheckMarkView()
    
    private lazy var taskNameLabelAndDueDateLabelStackView = UIStackView.makeVerticalStackView(with: [taskNameLabel, dueDateLabel], distribution: .equalSpacing, spacing: 0)
    
    let taskNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.preferredFont(for: .body, weight: .regular)
        label.textColor = .paragraphTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(for: .footnote, weight: .regular)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        setupCell()
        setupSubviews()
        setupDelegates()
    }
    
    deinit {
        print("ToDoListItemsCollectionViewCell deallocated")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .elevatedBackgroundColor
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.075
        layer.shadowOffset = CGSize(width: 0, height: 3.75)
    }
    
    private func setupSubviews() {
        addSubview(checkMarkView)
        
        checkMarkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        checkMarkView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                
        addSubview(taskNameLabelAndDueDateLabelStackView)
        
        taskNameLabelAndDueDateLabelStackView.anchor(topAnchor: topAnchor, rightAnchor: trailingAnchor, bottomAnchor: bottomAnchor, leftAnchor: checkMarkView.trailingAnchor, topPadding: 10, rightPadding: 20, bottomPadding: 10, leftPadding: 5, height: 0, width: 0)
    }
    
    private func setupDelegates() {
        checkMarkView.checkMarkViewDelegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkMarkView.isHidden = false
        toDoItem = nil
        checkMarkView.setToInitialState()
        taskNameLabel.attributedText = NSAttributedString(string: "", attributes: nil)
        dueDateLabel.text = ""
        if dueDateLabel.superview == nil {
            taskNameLabelAndDueDateLabelStackView.addArrangedSubview(dueDateLabel)
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleKeyboardTap() {
        taskNameLabel.becomeFirstResponder()
    }
    
    // MARK: - CheckMarkDelegate
    
    func didTapCheckMark(isChecked: Bool) {
        if let item = toDoItem {
            item.isCompleted = isChecked
            self.performTaskLabelAnimation(with: isChecked)
            delegate?.didCompleteTask(task: item)
        }
    }
    
    // MARK: - Animations
    
    private func performTaskLabelAnimation(with value: Bool) {
        UIView.transition(with: taskNameLabel, duration: 0.25, options: .transitionCrossDissolve) {
            self.taskNameLabel.attributedText = value ? NSAttributedString(string: self.taskNameLabel.text!, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.paragraphTextColor.withAlphaComponent(0.75), NSAttributedString.Key.font: UIFont.preferredFont(for: .body, weight: .regular)]) : NSAttributedString(string: self.taskNameLabel.text!, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(for: .body, weight: .regular), NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.byWord.rawValue, NSAttributedString.Key.foregroundColor: UIColor.paragraphTextColor])
        }
    }
    
    private func animateBackgroundColor(to color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = color
        }
    }
    
    func animateCheckmarkView(isHidden value: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.checkMarkView.isHidden = value
        }
    }
    
}
