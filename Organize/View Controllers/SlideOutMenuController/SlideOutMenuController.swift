//
//  SlideOutMenuController.swift
//  Organize
//
//  Created by Daniel Valencia on 7/15/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import PhotosUI

class SlideOutMenuController: UITableViewController, PHPickerViewControllerDelegate {
    
    // MARK: - Properties
    
    unowned let baseController: BaseController
    
    weak var createListDelegate: CreateListDelegate?
    
    weak var selectListDelegate: SelectListDelegate?
    
    var toDoItemLists = [ToDoItemList]()
    
    // MARK: - Initailization
    
    init(baseController: BaseController) {
        self.baseController = baseController
        super.init(style: .grouped)
    }
    
    deinit {
        print("SlideOutMenuController deallocated")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setupTableView()
    }
    
    // MARK: - Selectors
    
    @objc func handleSignout() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    
                    if let parent = self.parent {
                        parent.dismiss(animated: true, completion: nil)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    @objc func handleCreateNewListTap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                
        let alertViewController = UIAlertController(title: "Create a new List", message: "Enter a name for your new list", preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertViewController.addAction(UIAlertAction(title: "Create", style: .default, handler: { (_) in
            if let textField = alertViewController.textFields?[0] {
                if !textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                    let uuid = UUID().uuidString
                    let toDoItemList = ToDoItemList(name: textField.text!, created: Date(), toDoItems: [])
                    
                    if let user = Auth.auth().currentUser {
                        let path = Firestore.firestore().collection("users").document(user.uid).collection("to_do_items").document(uuid)
                        
                        self.toDoItemLists.append(toDoItemList)
                        self.tableView.insertRows(at: [IndexPath(row: self.toDoItemLists.count - 1, section: 0)], with: .automatic)
                        self.tableView.selectRow(at: IndexPath(row: self.toDoItemLists.count - 1, section: 0), animated: true, scrollPosition: .top)
                        
                        toDoItemList.path = path
                        
                        self.createListDelegate?.didCreateNewList(list: toDoItemList)
                        
                        path.setData(["list_name": toDoItemList.name, "created": Timestamp(date: toDoItemList.created)])
                    }
                }
            }
        }))
        
        alertViewController.addTextField { (textField) in
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        
        present(alertViewController, animated: true)
    }
    
    @objc func closeMenu() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        baseController.animateMenu(to: .closed)
    }
    
    @objc func didTapProfileImageView() {
        if let header = tableView.headerView(forSection: 0) as? ProfileTableViewHeader {
            if header.profileImageView.image != UIImage(named: "person.crop.circle") {
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                alertController.addAction(UIAlertAction(title: "Change Photo", style: .default, handler: { (_) in
                    self.presentPHPickerViewController()
                }))
                alertController.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: { (_) in
                    self.deleteOnlyPhotoFromStorage()
                }))
                present(alertController, animated: true)
            } else {
                presentPHPickerViewController()
            }
        }
    }
    
    func presentPHPickerViewController() {
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1
        
        let viewController = PHPickerViewController(configuration: configuration)
        viewController.delegate = self
        
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    self.present(viewController, animated: true)
                } else {
                    self.present(makeAlertViewController(with: "Error", message: "To set a profile image, access to your media library is required"), animated: true)
                }
            }
        }
    }
    
    // MARK: - PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self.present(makeAlertViewController(with: "Error", message: "Image could not be loaded in."), animated: true)
                        }
                    } else {
                        if let profileImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.setProfileImage(with: profileImage)
                            }
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func setProfileImage(with image: UIImage) {
        if let header = tableView.headerView(forSection: 0) as? ProfileTableViewHeader {
            UIView.transition(with: header.profileImageView, duration: 0.5, options: .transitionCrossDissolve) {
                header.profileImageView.image = image
            }
        }
        
        saveFileToStorage(image)
    }
    
    private func saveFileToStorage(_ image: UIImage) {
        if let user = Auth.auth().currentUser {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let storageLocation = Storage.storage().reference().child("users").child(user.uid).child("profile_image")
                    
                storageLocation.putData(imageData, metadata: nil) { (_, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        Firestore.firestore().collection("users").document(user.uid).updateData(["profile_image_url": storageLocation.fullPath])
                    }
                }
            }
        }
    }
    
    private func deleteOnlyPhotoFromStorage() {
        if let user = Auth.auth().currentUser {
            Storage.storage().reference().child("users").child(user.uid).child("profile_image").delete { (error) in
                if let error = error {
                    self.present(makeAlertViewController(with: "Error", message: error.localizedDescription), animated: true)
                } else {
                    if let header = self.tableView.headerView(forSection: 0) as? ProfileTableViewHeader {
                        UIView.transition(with: header.profileImageView, duration: 0.5, options: .transitionCrossDissolve) {
                            header.profileImageView.image = UIImage(named: "person.crop.circle")
                        }
                    }
                }
            }
        }
    }
    
}
