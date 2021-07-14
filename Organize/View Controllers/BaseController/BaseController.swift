//
//  BaseController.swift
//  Organize
//
//  Created by Daniel Valencia on 7/23/21.
//

import UIKit

enum MenuState {
    case opened, closed
}

class BaseController: UIViewController {
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return menuState == .opened ? .lightContent : traitCollection.userInterfaceStyle == .light ? .darkContent : .lightContent
    }
    
    var menuState: MenuState = .closed {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    lazy var menuSwipeLimit = view.frame.width * 0.75
    
    lazy var slideOutMenuController: SlideOutMenuController = { [unowned self] in
        let controller = SlideOutMenuController(baseController: self)
        return controller
    }()
    
    lazy var slideOutMenuControllerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    lazy var homeController: HomeController = { [unowned self] in
        let controller = HomeController(baseController: self)
        return controller
    }()
    
    lazy var homeControllerContainer: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        
        view.addSubview(homeController.view)
        self.addChild(homeController)
        homeController.didMove(toParent: self)
                
        homeController.view.translatesAutoresizingMaskIntoConstraints = false
        
        homeController.view.anchor(topAnchor: view.topAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor, leftAnchor: view.leadingAnchor, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: 0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .baseViewControllerBackgroundColor
        setupSubviews()
        setupGestureRecognizers()
    }
    
    private func setupSubviews() {
        view.addSubview(homeControllerContainer)
        view.addSubview(slideOutMenuControllerContainer)
        
        homeControllerContainer.anchor(topAnchor: view.topAnchor, rightAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor, leftAnchor: view.leadingAnchor, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: 0)
        
        slideOutMenuControllerContainer.anchor(topAnchor: view.topAnchor, rightAnchor: view.leadingAnchor, bottomAnchor: view.bottomAnchor, leftAnchor: nil, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: menuSwipeLimit)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupSlideOutMenuController() // This is called in this method because of a warning that will appear if it is done in viewDidLoad
    }
    
    private func setupSlideOutMenuController() {
        slideOutMenuControllerContainer.addSubview(slideOutMenuController.view)
        addChild(slideOutMenuController)
        slideOutMenuController.didMove(toParent: self)
        
        slideOutMenuController.view.translatesAutoresizingMaskIntoConstraints = false
        slideOutMenuController.view.anchor(topAnchor: slideOutMenuControllerContainer.topAnchor, rightAnchor: slideOutMenuControllerContainer.trailingAnchor, bottomAnchor: slideOutMenuControllerContainer.bottomAnchor, leftAnchor: slideOutMenuControllerContainer.leadingAnchor, topPadding: 0, rightPadding: 0, bottomPadding: 0, leftPadding: 0, height: 0, width: 0)
    }
    
    private func setupGestureRecognizers() {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleMenuSwipe(gesture:))))
    }
    
}
