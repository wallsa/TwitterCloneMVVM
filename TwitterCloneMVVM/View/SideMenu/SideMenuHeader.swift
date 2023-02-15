//
//  SideMenuHeader.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 13/02/23.
//

import UIKit

class SideMenuHeader:UIView{
//MARK: - Properties
    
    private var user : User
        
    private lazy var userProfileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        imageView.layer.borderWidth = 4
        imageView.setDimensions(height: 80, width: 80)
        imageView.layer.cornerRadius = 80 / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let divisorView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .backgroundColor
        return label
    }()
    
    private let followingLabel : UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self , action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private let followersLabel : UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self , action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    

//MARK: - Lifecycle
    
    
    init(user: User, frame: CGRect) {
        self.user = user
        
        super.init(frame: frame)
        configure()
        configureUI()
        print("DEBUG: USER ON SIDE MENU HEADER \(user)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

//MARK: - Helper Functions
    
    func configure(){

        
        addSubview(userProfileImage)
        userProfileImage.centerY(inview: self, leftAnchor: leftAnchor, paddinLeft: 8, constant: 10)
        
        addSubview(fullnameLabel)
        fullnameLabel.anchor(top: userProfileImage.topAnchor, left: userProfileImage.rightAnchor, right: rightAnchor, paddingLeft: 8)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: fullnameLabel.bottomAnchor, left: userProfileImage.rightAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8)
        
        addSubview(divisorView)
        divisorView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1)
        
        
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        addSubview(followStack)
        followStack.axis = .horizontal
        followStack.distribution = .fillProportionally
        followStack.spacing = 4
        followStack.anchor(left: userProfileImage.rightAnchor, bottom: userProfileImage.bottomAnchor, paddingLeft: 8)
       
        
       
        
    }
    
    func configureUI(){
        let viewModel = ProfileViewModel(user: user)
        print("DEBUG: View model \(viewModel)")
        fullnameLabel.text = viewModel.userFullName
        usernameLabel.text = viewModel.userName

        userProfileImage.sd_setImage(with: viewModel.userProfileImageURL)
        
        followersLabel.attributedText = viewModel.followersString
        followingLabel.attributedText = viewModel.followingString
    }

//MARK: - Selectors
    
    @objc func handleFollowersTapped(){
        
    }
    
    @objc func handleFollowingTapped(){
        
    }
}

