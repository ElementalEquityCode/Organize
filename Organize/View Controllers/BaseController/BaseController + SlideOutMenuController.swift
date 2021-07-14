//
//  BaseController + SlideOutMenuController.swift
//  Organize
//
//  Created by Daniel Valencia on 7/23/21.
//

import UIKit

extension BaseController {
    
    // MARK: - SlideOutMenuController
    
    @objc func handleOpenMenu() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        animateMenu(to: .opened)
    }
    
    @objc func handleMenuSwipe(gesture: UIPanGestureRecognizer) {
        if homeController.addTaskTextField.isFirstResponder {
            return
        }
        
        var translationX = gesture.translation(in: nil).x
        let velocity = gesture.translation(in: nil).x
        
        if menuState == .opened {
            translationX += menuSwipeLimit
        }
        
        translationX = max(0, translationX)
        translationX = min(translationX, menuSwipeLimit)
        
        homeController.menuGradientView.alpha = (translationX / menuSwipeLimit) * 0.25
        
        if gesture.state == .changed {
            homeControllerContainer.transform = CGAffineTransform(translationX: translationX, y: 0)
            slideOutMenuControllerContainer.transform = CGAffineTransform(translationX: translationX, y: 0)
                        
            self.homeController.listCollectionViewController.collectionViewLayout.invalidateLayout()
        } else if gesture.state == .ended {
            if velocity >= 40 && menuState == .closed {
                animateMenu(to: .opened)
                return
            } else if velocity <= -40 && menuState == .opened {
                animateMenu(to: .closed)
                return
            }
            
            if menuState == .closed {
                if translationX >= menuSwipeLimit / 2 {
                    animateMenu(to: .opened)
                } else {
                    animateMenu(to: .closed)
                }
            } else {
                if translationX <= menuSwipeLimit / 2 {
                    animateMenu(to: .closed)
                } else {
                    animateMenu(to: .opened)
                }
            }
        }
    }
    
    // MARK: - Animations
    
    func animateMenu(to state: MenuState) {
        menuState = state
                
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut, .allowUserInteraction]) {
            self.homeControllerContainer.transform = state == .opened ? CGAffineTransform(translationX: self.menuSwipeLimit, y: 0) : .identity
            self.slideOutMenuControllerContainer.transform = state == .opened ? CGAffineTransform(translationX: self.menuSwipeLimit, y: 0) : .identity
            
            self.view.layoutIfNeeded()

            self.homeController.menuGradientView.alpha = state == .opened ? 0.35 : 0
            
            self.homeController.listCollectionViewController.collectionViewLayout.invalidateLayout()
        }
    }
    
}
