//
//  TweetViewModel.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 06/01/23.
//

import UIKit

struct TweetViewModel {
    let tweet:Tweet
    let user:User
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    var profileImageURL : URL?{
        return tweet.user.profileImageUrl
    }
    
    var timestamp:String{
        let formmater = DateComponentsFormatter()
        formmater.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formmater.maximumUnitCount = 1
        formmater.unitsStyle = .brief
        let now = Date()
        return formmater.string(from: tweet.timestamp, to: now) ?? ""
    }
    
    var userInfoText:NSAttributedString{
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let name = NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        let date = NSAttributedString(string: " · \(timestamp)", attributes: [.font:UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        
        title.append(name)
        title.append(date)
        
        return title
                                              
    }
}
