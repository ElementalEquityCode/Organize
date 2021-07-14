//
//  LoginLoadingIndicator.swift
//  Organize
//
//  Created by Daniel Valencia on 7/16/21.
//

import UIKit

extension UIActivityIndicatorView {
    
    static func makeLoginLoadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.color = .subheadingLabelFontColor
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
}
