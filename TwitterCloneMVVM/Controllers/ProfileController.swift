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
    
    private let user:User
    
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.isNavigationBarHidden = true
    }

//MARK: - API
    
    func fetchUserTweets(){
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
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
    func actionButtonFollowAndUnfollowPressed() {
        print("DEBUG: Action Button FOLLOW AND UNFOLLOW")
    }
    
    func actionButtonEditProfilePressed() {
        print("DEBUG: Action Button EDIT PROFILE")
    }
    
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
