//
//  UploadTweetController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 04/01/23.
//

//FIXME: - Adicionar um switch para configurar inteiramente a View de acordo com a config

import UIKit
import SDWebImage

enum ActionButtonConfig{
    case tweet
    case reply
}


class UploadTweetController:UIViewController{

//MARK: - Properties
    
    private var user:User
    
    private let config:UploadTweetConfig
    
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private lazy var actionButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.setDimensions(height: 32, width: 64)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleTweet), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: 48, width: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: user.profileImageUrl)
        return imageView
    }()
    
    private let textView : CaptionTextView = {
        let textView = CaptionTextView()
        textView.placeholderLabel.text = "What's happening? "
        return textView
    }()
    
    private lazy var replyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Replying to @satanaz"
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
//MARK: - Life Cycle
    
    init(user: User, config:UploadTweetConfig) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
 
    }
    
//MARK: - Selectors
    
    @objc func handleCancel(){
        dismiss(animated: true)
    }
    
    @objc func handleTweet(){
        //Notificacao para o usuario caso o tweet seja nil
        guard let caption = textView.text else {return}
        TweetService.shared.uploadTweet(caption: caption, type: config) { error , ref in
            if let error = error {
                print("DEBUG: An error ocurred uploading the tweet")
            }
            
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)            }
            print("DEBUG: Sucessfully uploaded")
            self.dismiss(animated: true)
        }
    }
    
//MARK: - API
    
//MARK: - Helpers
    func configureUI(){
        configureNavigationbar()
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, textView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        textView.placeholderLabel.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let userToReply = viewModel.replyText else {return}
        
        replyLabel.text = userToReply
    }
    
    
    
    func configureNavigationbar(){
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}
