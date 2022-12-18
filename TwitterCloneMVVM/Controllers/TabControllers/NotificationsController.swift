//
//  NotificationsController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit

class NotificationsController: UIViewController {

//MARK: - Properties
        

//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
//MARK: - Helper Functions
        
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = Constants.NavBar.notificationsTitle
    }

     

}
