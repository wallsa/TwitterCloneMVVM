//
//  ContainerController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 12/02/23.
//

import UIKit
import Firebase

class ContainerController:UIViewController{
//MARK: - Properties
    
    private let tabController = MainTabController()
    private let menuController = MenuController()
    private var isExpanded = false
    
    private lazy var xOrigin = self.view.frame.width - 80
    
    private let blackView = UIView()
    
    private var user:User?{
        didSet{
            guard let user = user else {return}
            tabController.user = user
            guard let nav = tabController.viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            feed.delegate = self
        }
    }

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }

//MARK: - API
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            configure()
            fetchUser()
        }
    }
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            print("DEBUG: The user is \(user)")
            self.user = user
        }
    }

//MARK: - Helper Functions

    func configure(){
        configureMainTabController()
        configureSideMenuController()
        configureBlackView()
    }
    
    func configureMainTabController(){
        addChild(tabController)
        tabController.didMove(toParent: self)
        view.addSubview(tabController.view)
       
    }
    
    func configureSideMenuController(){
        addChild(menuController)
        menuController.didMove(toParent: self)
        view.insertSubview(menuController.view, at: 0)
    }
    
    func configureBlackView(){
        blackView.frame = CGRect(x: xOrigin, y: 0, width: 80, height: self.view.frame.height)
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.alpha = 0
        
        view.addSubview(blackView)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self , action: #selector(dismissMenu)))
    }
    
    func animateMenu(shouldExpand:Bool, completion: ((Bool) -> ())? = nil){
        if shouldExpand{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.tabController.view.frame.origin.x = self.xOrigin
                self.blackView.alpha = 1
            }, completion: nil)
        }else{
            self.blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.tabController.view.frame.origin.x = 0
            }, completion: completion)
        }
    }

//MARK: - Selectors
    
    @objc func dismissMenu(){
        isExpanded = false
        animateMenu(shouldExpand: isExpanded)
    }
}

extension ContainerController:FeedControllerDelegate{
    func sideMenuToggle() {
        print("DEBUG: Toggle on container")
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
    
    
}

