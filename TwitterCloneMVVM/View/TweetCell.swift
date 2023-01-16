//
//  TweetCell.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 05/01/23.
//

import UIKit

//MARK: - Delegate
protocol TweetCellDelegate:AnyObject{
    func commentPressed(_ cell:TweetCell)
    func retweetPressed(_ cell:TweetCell)
    func likePressed()
    func sharePressed()
    func imageProfilePressed(_ cell:TweetCell)
}

class TweetCell:UICollectionViewCell{
//MARK: - Properties
    
    var tweet:Tweet?{
        didSet {configure()}
    }
    //Memory cycle and strong reference
    weak var delegate:TweetCellDelegate?
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: 48, width: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .twitterBlue
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTapped)))
        return imageView
    }()
    
    let captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let infoLabel = UILabel()
    
    private let divisorView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let commentButton : UIButton = {
        return UIButton().createTweetCellButton(withImage: Constants.TweetCellImages.comment, selectorName: #selector(handleComment))
    }()
    
    private let retweetbutton : UIButton = {
        return UIButton().createTweetCellButton(withImage: Constants.TweetCellImages.retweet, selectorName: #selector(handleRetweet))
    }()
    
    private let likeButton : UIButton = {
        return UIButton().createTweetCellButton(withImage: Constants.TweetCellImages.like, selectorName: #selector(handleLike))
    }()
    
    private let shareButton : UIButton = {
        return UIButton().createTweetCellButton(withImage: Constants.TweetCellImages.share, selectorName: #selector(handleShare))
    }()
    
    
    
    
//MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - Selectors
    
    @objc func handleComment(){
        print("DEBUG: comment pressed")
        delegate?.commentPressed(self)
    }
    
    @objc func handleRetweet(){
        print("DEBUG: retweet pressed")
        delegate?.retweetPressed(self)
    }
    
    @objc func handleLike(){
        print("DEBUG: like pressed")
        delegate?.likePressed()
    }
    
    @objc func handleShare(){
        print("DEBUG: share pressed")
        delegate?.sharePressed()
    }
    
    @objc func handleImageTapped(){
        print("DEBUG: image pressed")
        delegate?.imageProfilePressed(self)
    }
    
//MARK: - Helper functions
    
    private func configureCell(){
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 6, paddingRight: 6)
        
        addSubview(divisorView)
        divisorView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1)
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton, retweetbutton, likeButton, shareButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 72
        addSubview(buttonStack)
        buttonStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        buttonStack.centerX(inview: self)
    }
    
    private func configure(){
        guard let tweet = tweet else {return}
        let viewModel = TweetViewModel(tweet: tweet)
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        captionLabel.text = tweet.caption
        infoLabel.attributedText = viewModel.userInfoText
        
    }
}
