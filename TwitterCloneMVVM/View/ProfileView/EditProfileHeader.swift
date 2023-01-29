//
//  EditProfileHeader.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 28/01/23.
//

import UIKit

protocol EditProfileHeaderDelegate:AnyObject{
    func didTapChangeProfilePhoto()
}

class EditProfileHeader:UIView{
    
//MARK: - Properties
    
    private let user : User
    
    weak var delegate:EditProfileHeaderDelegate?
    
    lazy var userProfileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        imageView.setDimensions(height: 100, width: 100)
        imageView.layer.cornerRadius = 100 / 2
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: user.profileImageUrl)
        return imageView
    }()
    
    private lazy var changeImageButton : UIButton = {
        let button = UIButton()
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self , action: #selector(handleChangeImage), for: .touchUpInside)
        return button
    }()

//MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        configure()
        backgroundColor = .twitterBlue

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - API

//MARK: - Helper Functions
    
    private func configure(){
        addSubview(userProfileImage)
        userProfileImage.centerX(inview: self)
        userProfileImage.centerY(inview: self, constant: -16)
        
        addSubview(changeImageButton)
        changeImageButton.centerX(inview: self)
        changeImageButton.anchor(top: userProfileImage.bottomAnchor, paddingTop: 8)
        
    }

//MARK: - Selectors
    
    @objc func handleChangeImage(){
        delegate?.didTapChangeProfilePhoto()
    }
}
