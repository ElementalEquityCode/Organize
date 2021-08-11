//
//  ToDoItem.swift
//  Organize
//
//  Created by Daniel Valencia on 7/17/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ToDoItem: Decodable {
    
    // MARK: - Properties
    
    var path: DocumentReference?
    var name: String
    var isCompleted: Bool {
        didSet {
            path!.updateData(["is_completed": isCompleted])
        }
    }
    var created: Date
    var dueDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case name
        case isCompleted="is_completed"
        case created
        case dueDate="due_date"
    }
    
    // MARK: - Initialization
    
    init(name: String, isCompleted: Bool, created: Date, dueDate: Date? = nil, path: DocumentReference) {
        self.name = name
        self.isCompleted = isCompleted
        self.created = created
        self.path = path
        self.dueDate = dueDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.isCompleted = try container.decode(Bool.self, forKey: CodingKeys.isCompleted)
        
        self.created = Date()
        
        do {
            let dateString = try container.decode(String.self, forKey: CodingKeys.created)
            if let date = makeGeneralDateFormatter().date(from: dateString) {
                self.created = date
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Mutators
    
    func deleteFromDatabase() {
        path!.delete()
    }
    
    func updateToDoItem(dueDate: Timestamp? = nil) {
        path!.updateData(["name": name, "due_date": dueDate ?? NSNull()]) 
    }
    
}
