//
//  UIColorExtension.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit

extension UIColor {
    
    static let baseViewControllerBackgroundColor = UIColor(red: 16/255, green: 24/255, blue: 39/255, alpha: 1)
    
    static let primaryBackgroundColor = UIColor.systemBackground
    
    static let secondaryBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .black
        } else {
            return UIColor(red: 250/255, green: 250/255, blue: 255/255, alpha: 1)
        }
    }
    
    static let elevatedBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .secondarySystemBackground
        } else {
            return .white
        }
    }
        
    static let primaryColor = UIColor(red: 45/255, green: 119/255, blue: 246/255, alpha: 1)
    
    static let secondaryColor = UIColor(red: 218/255, green: 45/255, blue: 245/255, alpha: 1)

    static let titleLabelFontColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.label
        } else {
            return UIColor(red: 43/255, green: 52/255, blue: 83/255, alpha: 1)
        }
    }
    
    static let subheadingLabelFontColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 210/255, green: 215/255, blue: 225/255, alpha: 1)
        } else {
            return UIColor(red: 129/255, green: 134/255, blue: 145/255, alpha: 1)
        }
    }
    
    static let textFieldBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.label
        } else {
            return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        }
    }
    
    static let placeholderTextColor = UIColor(red: 168/255, green: 167/255, blue: 174/255, alpha: 1)
    
    static let paragraphTextColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 178/255, green: 184/255, blue: 206/255, alpha: 1)
        } else {
            return UIColor(red: 78/255, green: 84/255, blue: 106/255, alpha: 1)
        }
    }
    
    static let generalTextFieldTextColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .darkGray
        } else {
            return UIColor(red: 78/255, green: 84/255, blue: 106/255, alpha: 1)
        }
    }
    
    static let slideOutMenuControllerPrimaryTextColor = UIColor(red: 208/255, green: 217/255, blue: 235/255, alpha: 1)

    static let progressBarColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)
        } else {
            return UIColor(red: 250/255, green: 250/255, blue: 255/255, alpha: 1)
        }
    }

}
