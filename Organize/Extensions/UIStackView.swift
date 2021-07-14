//
//  UIStackViewFactory.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit

extension UIStackView {
    
    static func makeVerticalStackView(with views: [UIView], distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.axis = .vertical
        return stackView
    }
    
    static func makeHorizontalStackView(with views: [UIView], distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
    
}
