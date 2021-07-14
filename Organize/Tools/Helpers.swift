//
//  Helpers.swift
//  Organize
//
//  Created by Daniel Valencia on 7/14/21.
//

import UIKit

func makeAlertViewController(with title: String, message: String) -> UIAlertController {
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertViewController.addAction(UIAlertAction(title: "Close", style: .default))
    return alertViewController
}

func makeAlertViewController(with title: String, message: String, completion: @escaping () -> Void) -> UIAlertController {
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertViewController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (_) in
        completion()
    }))
    return alertViewController
}

func makeGeneralDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    return dateFormatter
}

func makeDueDateDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
}

func performOpenKeyboardAnimation(moving view: UIView, _ duration: Double, _ height: CGFloat) {
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
        view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: height)
    }
}

func performCloseKeyboardAnimation(moving view: UIView, _ duration: Double) {
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
        view.transform = .identity
    }
}
