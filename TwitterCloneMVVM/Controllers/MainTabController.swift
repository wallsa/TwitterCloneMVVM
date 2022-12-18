//
//  MainTabController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit

class MainTabController: UITabBarController {

//MARK: - Properties
    
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        configureTabBarAppearance()
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

}
