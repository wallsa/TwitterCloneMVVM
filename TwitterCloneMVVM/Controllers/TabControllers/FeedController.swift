//
//  FeedController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "tweetCell"

class FeedController: UICollectionViewController {

//MARK: - Properties
    
    private var tweets:[Tweet]?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    var user:User?{
        didSet{
            configureLeftBarButton()
            fetchTweets()
        }
    }
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.isNavigationBarHidden = false
    }
    
//MARK: - API
    
    func fetchTweets(){
        TweetService.shared.fetchTweets { tweets in
            let orderTweets = tweets.sorted { $0.timestamp > $1.timestamp}
            self.tweets = orderTweets
        }
    }
   
//MARK: - Helper Functions
    
    func configureUI(){
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //collectionView.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: Constants.NavBar.twitterLogo))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(height: 44, width: 44)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLogoTap)))
        navigationItem.titleView = imageView

    }
    
    func configureLeftBarButton(){
        let profileImageView = UIImageView()
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.frame = CGRectMake(0, 0, 32, 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileTap)))
        profileImageView.sd_setImage(with: user?.profileImageUrl)
        profileImageView.layer.masksToBounds = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    
//MARK: - Selectors
    
    @objc func handleLogoTap(){
        print("DEBUG: Logo Tapped")
        fetchTweets()
    }
    
    @objc func handleProfileTap(){
        //Show profile
        print("DEBUG: Show profile")
    }
}

//MARK: - CollectionView Methods Data Source And Delegate

extension FeedController {
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.delegate = self
        cell.tweet = tweets?[indexPath.row]
        return cell
    }
    
}
//MARK: - CollectionView DelegateFlow - Size

extension FeedController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

//MARK: - TweetCell Delegate

extension FeedController:TweetCellDelegate{
    func imageProfilePressed(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }

    func commentPressed() {
        print("DEBUG: Comment handle in FEEDCONTROLLER")
    }
    
    func retweetPressed() {
        print("DEBUG: retweet handle in FEEDCONTROLLER")
    }
    
    func likePressed() {
        print("DEBUG: like handle in FEEDCONTROLLER")
    }
    
    func sharePressed() {
        print("DEBUG: share handle in FEEDCONTROLLER")
    }
    
    
}
