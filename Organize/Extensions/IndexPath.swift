//
//  IndexPath.swift
//  Organize
//
//  Created by Daniel Valencia on 10/9/21.
//

import Foundation

extension IndexPath {
    static func > (indexPath1: IndexPath, indexPath2: IndexPath) -> Bool {
        if indexPath1.section > indexPath2.section {
            return true
        } else if indexPath1.section < indexPath2.section {
            return false
        } else if indexPath1.section == indexPath2.section {
            return indexPath1.row > indexPath2.row
        }
        return false
    }
}
