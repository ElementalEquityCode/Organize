//
//  ToDoItemList.swift
//  Organize
//
//  Created by Daniel Valencia on 7/18/21.
//

import Foundation
import FirebaseFirestore

class ToDoItemList: Decodable, Equatable {
    
    // MARK: - Properties
    
    var name: String
    var created: Date
    var toDoItems = [ToDoItem]()
    var path: DocumentReference?
    
    enum CodingKeys: String, CodingKey {
        case name="list_name"
        case created
    }
    
    init(name: String, created: Date, toDoItems: [ToDoItem]) {
        self.name = name
        self.created = created
        self.toDoItems = toDoItems
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
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
    
    func editName(with newName: String) {
        self.name = newName
        
        if let path = path {
            path.updateData(["list_name": newName])
        }
    }
    
    func deleteListFromDatabase(completion: @escaping (Error?, Error?, Error?) -> Void) {
        if let path = path {
            var error1: Error?
            var error2: Error?
            var error3: Error?
            
            path.delete { (error) in
                error1 = error
            }
            
            path.collection("items").getDocuments { (snapshot, error) in
                if let error = error {
                    error2 = error
                } else {
                    for document in snapshot!.documents {
                        path.collection("items").document(document.documentID).delete { (error) in
                            if let error = error {
                                error3 = error
                            }
                        }
                    }
                    completion(error1, error2, error3)
                }
            }
        }
    }
    
    // MARK: - Equatable
    
    static func == (list1: ToDoItemList, list2: ToDoItemList) -> Bool {
        return list1.path?.documentID == list2.path?.documentID
    }
    
}
