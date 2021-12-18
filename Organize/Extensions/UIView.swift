//
//  UIViewExtension.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit

extension UIView {
    
    func anchorInCenterOfParent(parentView: UIView, topPadding: CGFloat, rightPadding: CGFloat, bottomPadding: CGFloat, leftPadding: CGFloat) {
        topAnchor.constraint(equalTo: parentView.topAnchor, constant: topPadding).isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -rightPadding).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -bottomPadding).isActive = true
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: leftPadding).isActive = true
    }
    
    func anchorToTopOfViewController(parentView: UIView, topPadding: CGFloat, rightPadding: CGFloat, leftPadding: CGFloat, height: CGFloat) {
        topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: topPadding).isActive = true
        trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor, constant: -rightPadding).isActive = true
        leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor, constant: leftPadding).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func anchor(topAnchor: NSLayoutYAxisAnchor?, rightAnchor: NSLayoutXAxisAnchor?, bottomAnchor: NSLayoutYAxisAnchor?, leftAnchor: NSLayoutXAxisAnchor?, topPadding: CGFloat, rightPadding: CGFloat, bottomPadding: CGFloat, leftPadding: CGFloat, height: CGFloat, width: CGFloat) {
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: topPadding).isActive = true
        }
        
        if let rightAnchor = rightAnchor {
            self.trailingAnchor.constraint(equalTo: rightAnchor, constant: -rightPadding).isActive = true
        }
        
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding).isActive = true
        }
        
        if let leftAnchor = leftAnchor {
            self.leadingAnchor.constraint(equalTo: leftAnchor, constant: leftPadding).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    static func makeBorderView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 45/255, green: 55/255, blue: 72/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    static func makeElevatedBackground() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .elevatedBackgroundColor
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.elevatedBackgroundShadowColor.cgColor
        view.layer.shadowRadius = 15
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        return view
    }
    
}
