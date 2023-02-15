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
    private var menuController : MenuController!
    private var isExpanded = false
    
    private lazy var xOrigin = self.view.frame.width - 80
    
    private let blackView = UIView()
    
    private var user:User?{
        didSet{
            print("DEBUG: USER ON CONTAINER SET")
            guard let user = user else {return}
            tabController.user = user
            guard let nav = tabController.viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            feed.delegate = self
            configureSideMenuController(withUser: user)
        }
    }

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .none
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
        }
    }
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUserWithStats(userUID: uid) { user in
            self.user = user
        }
    }
    
    func logoutUser(){
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch let error {
            print("DEBUG: Failed to signOut with error ... \(error.localizedDescription)")
        }
    }

//MARK: - Helper Functions

    func configure(){
        fetchUser()
        configureMainTabController()
        configureBlackView()
    
        
    }
    
    func configureMainTabController(){
        addChild(tabController)
        tabController.didMove(toParent: self)
        view.addSubview(tabController.view)
       
    }
    
    func configureSideMenuController(withUser user:User){
        menuController = MenuController(user: user)
        menuController.user = user
        menuController.delegate = self
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
        animateStatusBar()
    }
    
    func animateStatusBar(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func dismissSideMenu(){
        isExpanded = false
        animateMenu(shouldExpand: isExpanded)
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginController())
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }

//MARK: - Selectors
    
    @objc func dismissMenu(){
        dismissSideMenu()
    }
}

//MARK: - FeedControllerDelegate

extension ContainerController:FeedControllerDelegate{
    
    func sideMenuToggle(){
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}

//MARK: - SideMenuDelegate

extension ContainerController:SideMenuDelegate{
    func optionSelected(_ option: SideMenuOptions) {
        dismissSideMenu()
        switch option {
        case .settings:
            guard let user = user else {return}
            let controller = EditProfileController(user: user)
            let nav = UINavigationController().templateNavController(rootViewController: controller, backGrounColor: .twitterBlue)
            nav.isModalInPresentation = true
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        case .logout:
            let alert = UIAlertController().createLogoutAlert { _ in
                self.logoutUser()
            }
            present(alert, animated: true)
        }
    }
    
}
