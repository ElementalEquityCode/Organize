//
//  HomeController + SlideOutMenuController.swift
//  Organize
//
//  Created by Daniel Valencia on 7/23/21.
//

import UIKit

extension HomeController: UIGestureRecognizerDelegate {
        
    // MARK: - Selectors
    
    @objc func handleMenuTap() {
        if baseController.menuState == .opened {
            baseController.animateMenu(to: .closed)
        }
    }
    
    @objc func handleMenuCloseTap() {
        baseController.animateMenu(to: .closed)
    }
    
    // MARK: - UITapGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if baseController.menuState == .closed {
            return false
        } else {
            return true
        }
    }
    
}
