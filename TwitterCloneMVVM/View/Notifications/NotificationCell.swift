//
//  NotificationCell.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 22/01/23.
//

import UIKit

protocol NotificationCellDelegate:AnyObject{
    func userImageTapped(_ cell:NotificationCell)
    func followButtonTapped(_ cell:NotificationCell)
}


class NotificationCell: UITableViewCell {
    
    //MARK: - Properties
    
    weak var delegate:NotificationCellDelegate?
    
    var notification:Notification?{
        didSet{configureNotification()}
    }
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: 40, width: 40)
        imageView.layer.cornerRadius = 40 / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .twitterBlue
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTapped)))
        return imageView
    }()
    
    let notificationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "The user notificates you"
        return label
    }()
    
    private lazy var followButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.borderWidth = 2
        button.addTarget(self , action: #selector(handleFollowButton), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureNotificationCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper Functions
    
    func configureNotification(){
        guard let notification = notification else {return}
        let viewModel = NotificationViewModel(notification: notification)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.actionButtonTitle, for: .normal)
    }
    
    func configureNotificationCell(){
        contentView.addSubview(profileImageView)
        profileImageView.centerY(inview: self)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        
        contentView.addSubview(notificationLabel)
        notificationLabel.centerY(inview: self)
        notificationLabel.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 12)
        
        contentView.addSubview(followButton)
        followButton.centerY(inview: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 92, height: 26)
        followButton.layer.cornerRadius = 26 / 2
        
        
    }
    
    //MARK: - Selectors
    
    @objc func handleImageTapped(){
        print("DEBUG: Image tapped in cell")
        delegate?.userImageTapped(self)
    }
    
    @objc func handleFollowButton(){
        delegate?.followButtonTapped(self)
    }
}
