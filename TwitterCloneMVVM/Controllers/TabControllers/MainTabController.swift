//
//  MainTabController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit
import Firebase


class MainTabController: UITabBarController {

//MARK: - Properties
    
    var user:User?{
        didSet{
            configure()
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            feed.user = user
        }
    }
    
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
        view.backgroundColor = .white
        
    }
    
//MARK: - API
 
    
//MARK: - Selectors
    
    @objc func handleAction(){
        print("DEBUG: Handle Action")
        guard let user = user else {return}
        let nav = templateNavController(rootViewController: UploadTweetController(user: user, config: .tweet))
        present(nav, animated: true)
    }
    
//MARK: - Helpers Functions
    
    func configure(){
        configureViewControllers()
        configureTabBarAppearance()
        configureUI()
        //fetchUser()
    }
    
    func configureViewControllers(){
        let feed = templateNavController(image: UIImage(named: Constants.TabBarImages.home), rootViewController: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
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
    
    func templateNavController(image: UIImage? = nil, rootViewController: UIViewController) -> UINavigationController {
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

extension MainTabController:FeedControllerDelegate{
    func sideMenuToggle() {
        print("DEBUG: side menu toggle on tab controller")
    }
    
    
}
