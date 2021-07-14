//
//  CreateListDelegate.swift
//  Organize
//
//  Created by Daniel Valencia on 7/26/21.
//

import Foundation

protocol CreateListDelegate: AnyObject {
    func didCreateNewList(list: ToDoItemList)
}
