//
//  CompletionStatusDelegate.swift
//  Organize
//
//  Created by Daniel Valencia on 10/8/21.
//

import Foundation

protocol CompletionStatusDelegate: AnyObject {
    func didCompleteTask(task: ToDoItem)
}
