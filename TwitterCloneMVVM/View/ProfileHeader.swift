//
//  ProfileControllerHeader.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 06/01/23.
//

import UIKit

protocol ProfileHeaderDelegate:AnyObject {
    func backButtonPressed()
    func actionButtonFollowAndUnfollowPressed(_ header:ProfileHeader)
    func actionButtonEditProfilePressed()
}

enum ProfileHeadeActionButtonConfig{
    case followAndUnfollow
    case editProfile
    
    init(){
        self = .followAndUnfollow
    }
}

class ProfileHeader : UICollectionReusableView {
    
//MARK: - Properties
    
    weak var delegate:ProfileHeaderDelegate?
    
    var actionButtonConfig = ProfileHeadeActionButtonConfig()
    
    var user:User?{
        didSet{configure()}
    }
    
    private let filterBar = ProfileFilterView()
    
    
    private lazy var userProfileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        imageView.setDimensions(height: 80, width: 80)
        imageView.layer.cornerRadius = 80 / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        return view
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: Constants.backButton).withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self , action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderWidth = 1.25
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self , action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "Testando a capacidade da label ocupar mais de uma linha e se alterar"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let underLineView : UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let backUnderLineView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - Selectors
    
    @objc func handleBackButton(){
        print("DEBUG: Handle back button")
        delegate?.backButtonPressed()
    }
    
    @objc func handleEditProfileFollow(){
        print("DEBUG: Handle Edit button")
        switch actionButtonConfig {
        case .followAndUnfollow:
            delegate?.actionButtonFollowAndUnfollowPressed(self)
        case .editProfile:
            delegate?.actionButtonEditProfilePressed()
        }
    }
    
    @objc func handleFollowersTapped(){
        print("DEBUG: Handle Followers Tapped")
    }
    
    @objc func handleFollowingTapped(){
        print("DEBUG: Handle Following Tapped")
    }
    
//MARK: - Helper Functions
    
    func configureUI(){
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        addSubview(userProfileImage)
        userProfileImage.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12, width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        let nameStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        nameStack.axis = .vertical
        nameStack.distribution = .fillProportionally
        nameStack.spacing = 4
        addSubview(nameStack)
        nameStack.anchor(top: userProfileImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor , height: 50)
        filterBar.delegate = self
        
        addSubview(underLineView)
        underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width/CGFloat(ProfileFilterOptions.allCases.count), height: 2)
        
        addSubview(backUnderLineView)
        backUnderLineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width, height: 0.5)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        addSubview(followStack)
        followStack.axis = .horizontal
        followStack.distribution = .fillEqually
        followStack.spacing = 8
        followStack.anchor(top: nameStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
    }
    
    func configure(){
        guard let user = user else {return}
        let viewModel = ProfileViewModel(user: user)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        userProfileImage.sd_setImage(with: viewModel.userProfileImageURL)
        fullnameLabel.text = viewModel.userFullName
        usernameLabel.text = viewModel.userName
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
    }
    
    func animateUnderline(forCell cell:UICollectionViewCell){
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underLineView.frame.origin.x = xPosition
        }
    }
    
    
}
//MARK: - Profile Filter View Delegate

extension ProfileHeader:ProfileFilterViewDelegate{
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) else {return}
        animateUnderline(forCell: cell)
    }
}
