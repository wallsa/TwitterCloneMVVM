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
     
    private func fetchTweets(){
        TweetService.shared.fetchTweets { tweets in
            print(tweets)
            self.tweets = tweets
            self.updateLikes()
        }
    }
    
    private func checkLikes(_ orderTweets: [Tweet]) {
        for (index, tweet) in orderTweets.enumerated() {
            TweetService.shared.checkIfUserLikeTweet(tweet: tweet) { didLike in
                //FIXME: - Arrumar a ordem dos tweets com a info dos likes
                guard didLike == true else {return}

                self.tweets?[index].didLike = true
            }
        }
    }
   
//MARK: - Helper Functions
    
    func updateLikes(){
        if let tweets = tweets {
            checkLikes(tweets)
        }
    }
    
    func configureUI(){
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //collectionView.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: Constants.NavBar.twitterLogo))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(height: 44, width: 44)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLogoTap)))
        navigationItem.titleView = imageView
        
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else {return}
        collectionView.contentInset.bottom = tabBarHeight

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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedTweet = tweets?[indexPath.row] else {return}
        let controller = TweetController(tweet: selectedTweet)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
//MARK: - CollectionView DelegateFlow - Size

extension FeedController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Aqui utilizamos nossa funcao que descobre a altura necessaria para acomodar o texto do nosso tweet
        if let tweet = tweets?[indexPath.row]{
            let viewModel = TweetViewModel(tweet: tweet)
            let height = viewModel.size(forWidth: view.frame.width)
            return CGSize(width: view.frame.width, height: height + 80)
        }
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
    
    func commentPressed(_ cell: TweetCell) {
        print("DEBUG: Comment handle in FEEDCONTROLLER")
        guard let tweet = cell.tweet else {return}
        guard let user = user else {return}
        let nav = UINavigationController().templateNavController(rootViewController: UploadTweetController(user: user, config: .reply(tweet)))
        present(nav, animated: true)
    }

    
    func retweetPressed(_ cell: TweetCell) {
        print("DEBUG: Retweet handle in FEEDCONTROLLER")
        
    }
    
   
    func likePressed(_ cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        
        TweetService.shared.likeTweet(tweet: tweet) { error , dataref in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            guard !tweet.didLike else {return}
            NotificationService.shared.uploadNotification(type: .like, tweet: cell.tweet)
            
        }
    }
    
    func sharePressed() {
        print("DEBUG: share handle in FEEDCONTROLLER")
    }
    
    
}
