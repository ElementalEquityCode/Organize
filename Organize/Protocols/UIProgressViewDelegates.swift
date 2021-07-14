//
//  ShouldProgressViewAnimateDelegate.swift
//  Organize
//
//  Created by Daniel Valencia on 7/22/21.
//

import Foundation

protocol ShouldProgressViewAnimateDelegate: AnyObject {
    func progressViewDidAlreadyAnimate(for: (Bool, Int))
}

protocol AnimateProgressViewDelegate: AnyObject {
    func progressViewShouldAnimate()
}
