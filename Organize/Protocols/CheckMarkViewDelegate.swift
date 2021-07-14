//
//  CheckMarkViewDelegate.swift
//  Organize
//
//  Created by Daniel Valencia on 7/17/21.
//

import Foundation

protocol CheckMarkViewDelegate: AnyObject {
    func didTapCheckMark(isChecked: Bool)
}
