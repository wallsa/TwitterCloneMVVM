//
//  TweetService.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 04/01/23.
//

import Firebase


struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption:String, type:UploadTweetConfig ,completion:@escaping(Error?, DatabaseReference) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var value = ["uid" : uid,
                     "timestamp": Int(NSDate().timeIntervalSince1970),
                     "likes": 0,
                     "retweets": 0,
                     "caption" : caption] as [String:Any]
      
        switch type {
        case .tweet:
            //Fan-out Pattern
            REF_TWEETS.childByAutoId().updateChildValues(value) { error , dataref in
                guard let tweetID = dataref.key else {return}
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID:1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            value["replyingTo"] = tweet.user.username
            
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(value) { error , dataref in
                guard let replyID = dataref.key else {return}
                REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetID : replyID], withCompletionBlock: completion)
            }
        }
    }
    
    func fetchTweets(completion:@escaping ([Tweet]) -> ()){
        var tweets = [Tweet]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(uid).observe(.childAdded) { datasnap in
            let userFollowingUID = datasnap.key
            REF_USER_TWEETS.child(userFollowingUID).observe(.childAdded) { datasnap in
                let usersFollowingTweetsID = datasnap.key
                self.fetchTweet(forTweetId: usersFollowingTweetsID) { tweet in
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
        
        REF_USER_TWEETS.child(uid).observe(.childAdded) { datasnap in
            let usersFollowingTweetsID = datasnap.key
            self.fetchTweet(forTweetId: usersFollowingTweetsID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user:User, completion:@escaping ([Tweet]) -> ()){
        var tweets = [Tweet]()
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { datasnap in
            let tweetID = datasnap.key
            self.fetchTweet(forTweetId: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchReplies(forTweet tweetID:String, completion:@escaping ([Tweet]) -> ()){
        var tweets = [Tweet]()
        
        REF_TWEET_REPLIES.child(tweetID).observe(.childAdded) { datasnap in
            let replyID = datasnap.key
            print("DEBUG: The reply ID is \(replyID)")
            
            guard let tweetDictionary = datasnap.value as? [String:Any] else {return}
            guard let userID = tweetDictionary["uid"] as? String else {return}
            
            UserService.shared.fetchUser(uid: userID) { user in
                let tweet = Tweet(user: user, tweetID: replyID, dictionary: tweetDictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet:Tweet, completion:@escaping (DatabaseCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike {
            //unlike tweet - O Tweet estava com o status didLike = true, removemos o like
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue()
            REF_TWEET_LIKES.child(tweet.tweetID).child(uid).removeValue(completionBlock: completion)
            
        }else{
            //like tweet - O Tweet estava com o status didLike = false, aplicamos o like
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID:1]) { error , dataref in
                REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid:1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikeTweet(tweet:Tweet, completion:@escaping (Bool) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchTweet(forTweetId id:String, completion:@escaping (Tweet) -> ()){
        REF_TWEETS.child(id).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetId, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    func fetchUserLikes(uid:String, completion:@escaping ([Tweet]) -> ()){
        var likedTweets = [Tweet]()
        REF_USER_LIKES.child(uid).observe(.childAdded) { datasnap in
            TweetService.shared.fetchTweet(forTweetId: datasnap.key) { likedTweet in
                var tweet = likedTweet
                tweet.didLike = true
                likedTweets.append(tweet)
                completion(likedTweets)
            }
        }
    }
    
    func fetchUserReplies(forUser user:User, completion:@escaping ([Tweet]) -> ()){
        var replies = [Tweet]()
        
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { datasnap in
            let tweetID = datasnap.key
            guard let replyID = datasnap.value as? String else {return}
            REF_TWEET_REPLIES.child(tweetID).child(replyID).observeSingleEvent(of: .value) { datasnap in
                guard let tweetDictionary = datasnap.value as? [String:Any] else {return}
                guard let userID = tweetDictionary["uid"] as? String else {return}
                
                UserService.shared.fetchUser(uid: userID) { user in
                    let tweet = Tweet(user: user, tweetID: replyID, dictionary: tweetDictionary)
                    replies.append(tweet)
                    completion(replies)
                }
            }
        }
    }
}
    
    
    
    

