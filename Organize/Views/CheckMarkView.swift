//
//  CheckMarkView.swift
//  Organize
//
//  Created by Daniel Valencia on 7/16/21.
//

import UIKit

class CheckMarkView: UIView {
    
    // MARK: - Properties
    
    var primaryColorForCell: UIColor? {
        didSet {
            if let color = primaryColorForCell {
                contentView.backgroundColor = color
            }
        }
    }
    
    var isChecked = false {
        didSet {
            performCheckMarkViewAnimation(to: isChecked)
        }
    }
    
    weak var checkMarkViewDelegate: CheckMarkViewDelegate?
        
    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22.5 / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 22.5).isActive = true
        view.widthAnchor.constraint(equalToConstant: 22.5).isActive = true
        return view
    }()
        
    private let checkMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkmark"))
        imageView.alpha = 0
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let contentViewCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 22.5 / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 22.5).isActive = true
        view.widthAnchor.constraint(equalToConstant: 22.5).isActive = true
        view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        return view
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupView()
        setupSubviews()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupSubviews() {
        addSubview(contentView)
        contentView.addSubview(checkMarkImageView)
        contentView.insertSubview(contentViewCircleView, aboveSubview: checkMarkImageView)
        
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        checkMarkImageView.anchorInCenterOfParent(parentView: contentView, topPadding: 3.75, rightPadding: 3.75, bottomPadding: 3.75, leftPadding: 3.75)
        
        contentViewCircleView.anchor(topAnchor: contentView.topAnchor, rightAnchor: contentView.trailingAnchor, bottomAnchor: contentView.bottomAnchor, leftAnchor: contentView.leadingAnchor, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: 0)
    }
    
    private func setupGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCheckMarkTap)))
    }
    
    // MARK: - Selectors
    
    @objc private func handleCheckMarkTap() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        isChecked = !isChecked
        checkMarkViewDelegate?.didTapCheckMark(isChecked: isChecked)
    }
    
    // MARK: - Helpers
    
    func setToInitialState() {
        alpha = 1
        isChecked = false
        checkMarkImageView.alpha = 0
        contentViewCircleView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }
    
    // MARK: - Animations
    
    private func performCheckMarkViewAnimation(to value: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.checkMarkImageView.alpha = self.isChecked ? 1 : 0
            self.alpha = self.isChecked == true ? 1 : 0.75
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.contentViewCircleView.transform = self.isChecked ? CGAffineTransform(scaleX: 0.001, y: 0.001) : CGAffineTransform(scaleX: 0.85, y: 0.85)
            self.contentViewCircleView.backgroundColor = self.isChecked ? self.primaryColorForCell ?? .primaryColor : .white
        }
    }
    
}
