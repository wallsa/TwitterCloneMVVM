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
        view.backgroundColor = .systemPink
    }
    
//MARK: - Helpers Functions
    
    func configureViewControllers(){
        let feed = FeedController()
        let explore = ExploreController()
        let notifications = NotificationsController()
        let conversations = ConversationController()
        
        viewControllers = [feed, explore, notifications, conversations]
    }

}
