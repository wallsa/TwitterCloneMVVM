//
//  ProfileController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 06/01/23.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController:UICollectionViewController{
    
//MARK: - Properties
    
    private var user:User
    
    private var tweets:[Tweet]?{
        didSet{
            collectionView.reloadData()
        }
    }

//MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchUserTweets()
        checkIfUserIsFollowing()
        fetchUserStats()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

//MARK: - API
    
    func fetchUserTweets(){
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            let orderTweets = tweets.sorted { $0.timestamp > $1.timestamp}
            self.tweets = orderTweets
        }
    }
    
    func checkIfUserIsFollowing(){
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowing in
            self.user.isFollowed = isFollowing
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats(){
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    

//MARK: - Helper Functions
    
    func configure(){
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    

//MARK: - Selectors
    
    @objc func handleCancel(){
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Collection View Data Source and Delegates

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets?[indexPath.row]
        return cell
    }
}

//MARK: - CollectionView DelegateFlow - Size

extension ProfileController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let tweet = tweets?[indexPath.row] {
            let tweetVm = TweetViewModel(tweet: tweet)
            let height = tweetVm.size(forWidth: view.frame.width)
            return CGSize(width: view.frame.width, height: height + 80)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
}

//MARK: - CollectionView Header

extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        let viewModel = ProfileViewModel(user: user)
        header.user = user
        header.delegate = self
        header.actionButtonConfig = viewModel.actionButtonConfig
        return header
    }
}

//MARK: - Profile Header Delegate

extension ProfileController:ProfileHeaderDelegate{
    
    func actionButtonFollowAndUnfollowPressed(_ header: ProfileHeader) {
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error , dataref in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error , dataref in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                NotificationService.shared.uploadNotification(type: .follow, user: self.user)
            }
        }
    }
    
    
    func actionButtonEditProfilePressed() {
        print("DEBUG: Action Button EDIT PROFILE")
    }
    
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

