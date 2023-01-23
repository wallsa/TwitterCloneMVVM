//
//  TweetController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 13/01/23.
//

import UIKit

private let headerIdentifier = "TweetHeader"
private let cellIdentifier = "TweetCell"

class TweetController:UICollectionViewController{
    
//MARK: - Properties
    
    private let tweet:Tweet
    
    private var actionSheetLauncher:ActionSheetLaucher!
    
    private var replies:[Tweet]?{
        didSet{collectionView.reloadData()}
    }
    
//MARK: - Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    
  
//MARK: - API
    
    func fetchReplies(){
        TweetService.shared.fetchReplies(forTweet: tweet.tweetID) { replies in
            print("DEBUG: Replies \(replies)")
            let orderReplies = replies.sorted { $0.timestamp > $1.timestamp}
            self.replies = orderReplies
        }
    }
    
    func followUser(_ userUID:String){
        UserService.shared.followUser(uid: userUID) {  error , databaseref  in
            if let error = error {
                //FIXME: - Tratar o erro e informar usuario
                print("DEBUG: Error following the user \(error.localizedDescription)")
            }
        }
    }
    
    func unfollowUser(_ userUID:String){
        UserService.shared.unfollowUser(uid: userUID) { error , dataref in
            if let error = error {
                //FIXME: - Tratar o erro e informar usuario
                print("DEBUG: Error following the user \(error.localizedDescription)")
            }
        }
    }
    
//MARK: - Helper Functions
    
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    fileprivate func showActionSheetForUser(_ user:User) {
        actionSheetLauncher = ActionSheetLaucher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
    
//MARK: - Selectors
    
    @objc func handleBackTapped(){
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - CollectionView DataSource And Delegate

extension TweetController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies?[indexPath.row]
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout - Definindo tamanhos de celulas e header
extension TweetController:UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
    //Tamanho header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width)
        return CGSize(width: view.frame.width, height: height + 260)
    }
    //Tamanho célula
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    
}

//MARK: - Tweet Header Delegate
extension TweetController:TweetHeaderDelegate{
   
    func showActionSheet() {
        if tweet.user.isCurrentUser {
            showActionSheetForUser(tweet.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheetForUser(user)
            }
        }
    }
}

//MARK: - ActionSheetLaucher Delegate

extension TweetController:ActionSheetLaucherDelegate{
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            followUser(user.uid)
            
        case .unfollow(let user):
            unfollowUser(user.uid)

        case .report:
            print("DEBUG: REPORT TWEET")
            
        case .delete:
            print("DEBUG: DELETE TWEET")
        }
    }
}

