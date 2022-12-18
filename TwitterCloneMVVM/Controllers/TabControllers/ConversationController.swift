//
//  ConversationController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit

class ConversationController: UIViewController {

//MARK: - Properties
        

//MARK: - Life Cycle
        override func viewDidLoad() {
            super.viewDidLoad()
            configureUI()
        }
//MARK: - Helper Functions
        
        func configureUI(){
            view.backgroundColor = .white
            navigationItem.title = Constants.NavBar.messagesTitle
        }

     

}
