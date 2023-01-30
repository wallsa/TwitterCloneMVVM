//
//  TweetHeader.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 13/01/23.
//

import UIKit
import ActiveLabel

protocol TweetHeaderDelegate:AnyObject{
    func showActionSheet()
    func mentionUserTapped(_ mention:String)
}


class TweetHeader:UICollectionReusableView{
    
    
    
//MARK: - Properties
    
    var tweet:Tweet?{
        didSet{configureHeaderData()}
    }
    
    weak var delegate:TweetHeaderDelegate?
    
    private lazy var userProfileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        
        let tap = UITapGestureRecognizer(target: self , action: #selector(handleProfileImageTapp))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        imageView.layer.borderWidth = 4
        imageView.setDimensions(height: 48, width: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let replyingToLabel : ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
    let captionLabel : ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
    private let tweetDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var optionButton :UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(imageLiteralResourceName: Constants.downArrowButton).withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self , action: #selector(optionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var statusView : UIView = {
        let view = UIView()
        
        let divisor1 = UIView()
        divisor1.backgroundColor = .systemGroupedBackground
        view.addSubview(divisor1)
        divisor1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 1.0)
        
        let statsStack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        statsStack.spacing = 8
        statsStack.axis = .horizontal
        
        view.addSubview(statsStack)
        statsStack.centerY(inview: view)
        statsStack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divisor2 = UIView()
        divisor2.backgroundColor = .systemGroupedBackground
        view.addSubview(divisor2)
        divisor2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 1.0)
        return view
    }()
    
    private let retweetsLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        let tap = UITapGestureRecognizer(target: self , action: #selector(retweetsLabelTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        label.text = "0 Retweets"
        return label
    }()
    
    private let likesLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        let tap = UITapGestureRecognizer(target: self , action: #selector(likesLabelTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        label.text = "0 Likes"
        return label
    }()
    
    private let commentButton : UIButton = {
        return UIButton().createTweetCellButton(withImage: Constants.TweetCellImages.comment, selectorName: #selector(handleTweetComment))
    }()
    
    private let retweetbutton : UIButton = {
        return UIButton().createTweetCellButton(withImage: Constants.TweetCellImages.retweet, selectorName: #selector(handleTweetRetweet))
    }()
    
    private let likeButton : UIButton = {
        return UIButton().createTweetCellButton(withImage: Constants.TweetCellImages.like, selectorName: #selector(handleTweetLike))
    }()
    
    private let shareButton : UIButton = {
        return UIButton().createTweetCellButton(withImage: Constants.TweetCellImages.share, selectorName: #selector(handleTweetShare))
    }()
    
    private let divisorView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    

//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHeader()
        configureMentionHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - API

//MARK: - Helper Functions
    
    func configureMentionHandler(){
        captionLabel.handleMentionTap { mention in
            self.delegate?.mentionUserTapped(mention)
        }
    }
    
    func configureHeader(){
        
        let nameStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        nameStack.axis = .vertical
        nameStack.distribution = .fillProportionally
        nameStack.spacing = -6
        
        let stack = UIStackView(arrangedSubviews: [userProfileImage, nameStack])
        stack.spacing = 8
        
        let fullStack = UIStackView(arrangedSubviews: [replyingToLabel, stack])
        fullStack.axis = .vertical
        fullStack.distribution = .fillProportionally
        fullStack.spacing = 8
        
        addSubview(fullStack)
        fullStack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
     
        addSubview(captionLabel)
        captionLabel.anchor(top: fullStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 16 , paddingRight: 16)
        
        addSubview(tweetDateLabel)
        tweetDateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(statusView)
        statusView.anchor(top: tweetDateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, height: 40)
        
        addSubview(optionButton)
        optionButton.centerY(inview: fullStack)
        optionButton.anchor(right: rightAnchor, paddingRight: 8)
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton, retweetbutton, likeButton, shareButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 72
        addSubview(buttonStack)
        buttonStack.anchor(top: statusView.bottomAnchor, paddingTop: 16)
        buttonStack.centerX(inview: self)
        
        addSubview(divisorView)
        divisorView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1.5)
        
    }
    
    func configureHeaderData(){
        guard let tweet = tweet else {return}
        let viewModel = TweetViewModel(tweet: tweet)
        userProfileImage.sd_setImage(with: viewModel.profileImageURL)
        fullnameLabel.text = viewModel.userFullName
        usernameLabel.text = viewModel.userName
        captionLabel.text = tweet.caption
        tweetDateLabel.text = viewModel.tweetDate
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        
        replyingToLabel.isHidden = viewModel.replyingToTextShouldHide
        replyingToLabel.text = viewModel.replyingToText
    }
    


//MARK: - Selectors
    
    @objc func handleProfileImageTapp(){
        print("DEBUG: Profile Image tapped on TweetHeader")
    }
    
    @objc func optionButtonTapped(){
        print("DEBUG: Option Button tapped")
        delegate?.showActionSheet()
    }
    
    @objc func retweetsLabelTapped(){
        print("DEBUG: retweets label tapped")
    }
    
    @objc func likesLabelTapped(){
        print("DEBUG: likes label tapped")
    }
    
    @objc func handleTweetComment(){
        print("DEBUG: likes label tapped")
    }
    
    @objc func handleTweetRetweet(){
        print("DEBUG: likes label tapped")
    }
    
    @objc func handleTweetLike(){
        print("DEBUG: likes label tapped")
    }
    
    @objc func handleTweetShare(){
        print("DEBUG: likes label tapped")
    }
    
}
