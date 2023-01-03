//
//  MainTabController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit
import Firebase

enum ActionButtonConfiguration{
    case feed
    case explore
    case notifications
    case messages
    
    init() {
        self = .feed
    }
}

class MainTabController: UITabBarController {

//MARK: - Properties
    
    var actionButtonConfig = ActionButtonConfiguration()
    
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: Constants.newTweetButton), for: .normal)
        button.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        return button
    }()
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutUser()
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
            configureViewControllers()
            configureTabBarAppearance()
            configureUI()
        }
    }
    
    func logoutUser(){
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to signOut with error ... \(error.localizedDescription)")
        }
    }
    
//MARK: - Selectors
    
    @objc func handleAction(){
        print("DEBUG: Handle Action")
    }
    
//MARK: - Helpers Functions
    
    func configureViewControllers(){
        let feed = templateNavController(image: UIImage(named: Constants.TabBarImages.home), rootViewController: FeedController())
        
        let explore = templateNavController(image: UIImage(named: Constants.TabBarImages.search), rootViewController: ExploreController())
        
        let notifications = templateNavController(image: UIImage(named: Constants.TabBarImages.notifications), rootViewController: NotificationsController())
        
        let conversations = templateNavController(image: UIImage(named: Constants.TabBarImages.messages), rootViewController: ConversationController())
        
        viewControllers = [feed, explore, notifications, conversations]
    }
    
    func configureTabBarAppearance() {
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    func templateNavController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        return nav
    }
    
    func configureUI(){
        view.addSubview(actionButton)
        actionButton.anchor(bottom: tabBar.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 16, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }

}
