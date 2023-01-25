//
//  UploadTweetViewModel.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 13/01/23.
//

import UIKit

enum UploadTweetConfig{
    case tweet
    case reply(Tweet)
}


struct UploadTweetViewModel {
    
    let actionButtonTitle:String
    let placeholderText:String
    let shouldShowReplyLabel:Bool
    var replyText:String?

    
    init(config:UploadTweetConfig){
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happening ?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
    }
}

