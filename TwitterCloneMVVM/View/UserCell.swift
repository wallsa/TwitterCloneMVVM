//
//  UserCell.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 12/01/23.
//

import UIKit

class UserCell:UITableViewCell{
    
    
    //MARK: - Properties
    
    var user:User?{
        didSet{configureCell()}
    }
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: 40, width: 40)
        imageView.layer.cornerRadius = 40 / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .twitterBlue
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Fullname"
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Helper Functions
    
    private func configure(){
        addSubview(profileImageView)
        profileImageView.centerY(inview: self, leftAnchor: leftAnchor, paddinLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inview: profileImageView, leftAnchor: profileImageView.rightAnchor, paddinLeft: 12)
    }
    
    private func configureCell(){
        profileImageView.sd_setImage(with: user?.profileImageUrl)
        usernameLabel.text = user?.username
        fullnameLabel.text = user?.fullname
    }
    
    //MARK: - Selectors
}
