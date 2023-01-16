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
        
        let value = ["uid" : uid,
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
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(value, withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion:@escaping ([Tweet]) -> ()){
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            UserService.shared.fetchUser(uid: uid) { user in
                let tweetID = snapshot.key
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user:User, completion:@escaping ([Tweet]) -> ()){
        var tweets = [Tweet]()
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { datasnap in
            let tweetID = datasnap.key
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { datasnap in
                guard let dictionary = datasnap.value as? [String:Any] else {return}
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
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
    
}
    
    
    
    

