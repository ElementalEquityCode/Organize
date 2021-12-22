//
//  UIColorExtension.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit

extension UIColor {
    
    static let primaryBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? UIColor(red: 249/255, green: 250/255, blue: 252/255, alpha: 1) : UIColor(red: 11/255, green: 15/255, blue: 25/255, alpha: 1)
    }
    
    static let secondaryBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .black
        } else {
            return UIColor(red: 250/255, green: 250/255, blue: 255/255, alpha: 1)
        }
    }
    
    static let elevatedBackgroundColor = UIColor { (traitCollection: UITraitCollection) in
        return traitCollection.userInterfaceStyle == .light ? .white : UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1)
    }
    
    static let slideOutMenuControllerBackgroundColor = UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1)
        
    static let primaryColor = UIColor(red: 117/255, green: 130/255, blue: 235/255, alpha: 1)
    
    static let secondaryColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1)
    
    static let titleLabelFontColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? UIColor(red: 18/255, green: 24/255, blue: 40/255, alpha: 1) : UIColor(red: 237/255, green: 242/255, blue: 247/255, alpha: 1)
    }
    
    static let subheadingLabelFontColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? UIColor(red: 101/255, green: 116/255, blue: 139/255, alpha: 1) : UIColor(red: 160/255, green: 174/255, blue: 192/255, alpha: 1)
    }
    
    static let placeholderTextColor = UIColor(red: 168/255, green: 167/255, blue: 174/255, alpha: 1)
    
    static let paragraphTextColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 178/255, green: 184/255, blue: 206/255, alpha: 1)
        } else {
            return UIColor(red: 78/255, green: 84/255, blue: 106/255, alpha: 1)
        }
    }
    
    static let elevatedBackgroundShadowColor = UIColor { (traitCollection: UITraitCollection) in
        return traitCollection.userInterfaceStyle == .light ? UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 0.12) : UIColor(red: 0, green: 0, blue: 0, alpha: 0.24)
    }
    
    static let generalTextFieldFontColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .light ? .black : .white
    }
    
    static let generalTextFieldBorderColor = UIColor { (traitCollection: UITraitCollection) in
        return traitCollection.userInterfaceStyle == .light ? UIColor(red: 133/255, green: 133/255, blue: 133/255, alpha: 1) : UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
    }
    
    static let generalActionButtonFontColor = UIColor { (traitCollection: UITraitCollection) in
        return traitCollection.userInterfaceStyle == .light ? .white : UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1)
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
