//
//  UIButtonFactory.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit

extension UIButton {
    
    static func makeGeneralActionButton(with text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.5, weight: .semibold)
        button.setTitleColor(UIColor.generalActionButtonFontColor, for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        return button
    }
    
    static func makeClearBackgroundGeneralActionButton(with text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.5, weight: .semibold)
        button.setTitleColor(.primaryColor, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return button
    }
    
    static func makeClearBackgroundGeneralActionButton(with text: String, attributedString: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(NSAttributedString(string: text + " ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.paragraphTextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.5, weight: .medium)]))
        mutableAttributedString.append(NSAttributedString(string: attributedString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.5, weight: .bold)]))
        button.setAttributedTitle(mutableAttributedString, for: .normal)
        
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return button
    }
    
}
