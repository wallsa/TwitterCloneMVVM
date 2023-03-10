//
//  File.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import Foundation
import Firebase

//MARK: -  Referencias DataBase
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DATA_REF = Database.database().reference()
let REF_USERS = DATA_REF.child("users")
let REF_TWEETS = DATA_REF.child("tweets")
let REF_USER_TWEETS = DATA_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DATA_REF.child("user-followers")
let REF_USER_FOLLOWING = DATA_REF.child("user-following")
let REF_TWEET_REPLIES = DATA_REF.child("tweet-replies")
let REF_USER_LIKES = DATA_REF.child("user-likes")
let REF_TWEET_LIKES = DATA_REF.child("tweet-likes")
let REF_NOTIFICATIONS = DATA_REF.child("notifications")
let REF_USER_REPLIES = DATA_REF.child("user-replies")
let REF_USER_USERNAMES = DATA_REF.child("user-usernames")

//MARK: - Constants
struct Constants {
    
    static let twitterLogo = "TwitterLogo"
    static let newTweetButton = "new_tweet"
    static let backButton = "baseline_arrow_back_white_24dp"
    static let downArrowButton = "down_arrow_24pt"
    
    struct TabBarImages {
        static let home = "home_unselected"
        static let search = "search_unselected"
        static let notifications = "like_unselected"
        static let messages = "ic_mail_outline_white_2x-1"
    }
    
    struct NavBar{
        static let twitterLogo = "twitter_logo_blue"
        static let messagesTitle = "Messages"
        static let searchTitle = "Explore"
        static let notificationsTitle = "Notifications"
    }
    
    struct LoginAndSignupImages {
        static let emailImage = "ic_mail_outline_white_2x-1"
        static let passwordImage = "ic_lock_outline_white_2x"
        static let personImage = "ic_person_outline_white_2x"
        static let addPhotoImage = "plus_photo"
    }
    struct TweetCellImages {
        static let comment = "comment"
        static let retweet = "retweet"
        static let like = "like"
        static let share = "share"
        static let likeFill = "like_filled"
    } 
}
