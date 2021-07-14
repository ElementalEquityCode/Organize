//
//  EditToDoItemDelegate.swift
//  Organize
//
//  Created by Daniel Valencia on 7/29/21.
//

import Foundation

protocol EditToDoItemDelegate: AnyObject {
    func didEditItem(row: Int, toDoItem: ToDoItem)
    
    func didDeleteItem(row: Int)
}
