//
//  FeedController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit

class FeedController: UIViewController {

//MARK: - Properties
    
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
   
//MARK: - Helper Functions
    
    func configureUI(){
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: Constants.NavBar.twitterLogo))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
    }


}
