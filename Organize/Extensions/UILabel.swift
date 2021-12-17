//
//  UILabelFactory.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit

extension UILabel {
    
    static func makeTitleLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.text = text
        label.textColor = UIColor.titleLabelFontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeSubheadingLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium), NSAttributedString.Key.kern: 1.5, NSAttributedString.Key.foregroundColor: UIColor.subheadingLabelFontColor])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeParagraphLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17.5, weight: .regular)
        label.numberOfLines = 0
        label.text = text
        label.textColor = .paragraphTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
}
