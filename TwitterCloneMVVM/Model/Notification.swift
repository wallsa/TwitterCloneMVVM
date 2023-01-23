//
//  Notification.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 19/01/23.
//

import Foundation

enum NotificationType:Int, CustomStringConvertible{
    case follow
    case reply
    case like
    case retweet
    case mention
    
    var description: String{
        switch self {
        case .follow: return "started following you"
        case .reply: return "replied to your tweet"
        case .like: return "liked your tweet"
        case .retweet: return "retweet your tweet"
        case .mention: return "mention you"
        }
    }
}


struct Notification{
    
    var tweetID:String?
    var timestamp:Date!
    var user:User
    var type:NotificationType!
    
    init(user: User, dictionary:[String:Any]) {
        self.user = user
        
        if let tweetID = dictionary["tweetID"] as? String {
            self.tweetID = tweetID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double{
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int{
            self.type = NotificationType(rawValue: type)
        }
    }
    
}
