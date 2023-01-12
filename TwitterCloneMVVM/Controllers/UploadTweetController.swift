//
//  UploadTweetController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 04/01/23.
//

import UIKit
import SDWebImage

class UploadTweetController:UIViewController{

//MARK: - Properties
    
    private var user:User
    
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
        //FIXME: - Arrumar o numero de linhas da container
        //textView.textContainer.maximumNumberOfLines = 0
        textView.placeholderLabel.text = "What's happening? "
        return textView
    }()
    
//MARK: - Life Cycle
    
    init(user: User) {
        self.user = user
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
        TweetService.shared.uploadTweet(caption: caption) { error , ref in
            if let error = error {
                print("DEBUG: An error ocurred uploading the tweet")
            }
            print("DEBUG: Sucessfully uploaded")
            self.dismiss(animated: true)
        }
    }
    
//MARK: - API
    
//MARK: - Helpers
    func configureUI(){
        configureNavigationbar()
        let stack = UIStackView(arrangedSubviews: [profileImageView, textView])
        stack.axis = .horizontal
        stack.spacing = 12
        
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
    }
    
    func configureNavigationbar(){
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}
