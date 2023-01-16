//
//  ProfileHeaderViewModel.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 09/01/23.
//

import UIKit

enum ProfileFilterOptions:Int,CustomStringConvertible, CaseIterable {
    case tweets
    case retweets
    case likes
        
    var description: String{
        switch self {
        case .tweets: return "Tweets"
        case .retweets:return "Tweets & Replies"
        case .likes:return "Likes"
        }
    }
}

struct ProfileViewModel {
//MARK: - Properties
    
    private let user:User
    
    var followersString:NSAttributedString{
        return NSAttributedString().attributedText(withValue: user.stats?.followers ?? 0, text: "Followers")
    }
    
    var followingString:NSAttributedString{
        return NSAttributedString().attributedText(withValue: user.stats?.following ?? 0, text: "Following")
    }
    
    var userProfileImageURL:URL?{
        return user.profileImageUrl
    }
    
    var userFullName:String{
        return user.fullname
    }
    
    var userName:String{
        return "@\(user.username)"
    }
    
    var actionButtonTitle:String{
        if user.isCurrentUser{
            return "Edit Profile"
        }
        if !user.isFollowed && !user.isCurrentUser{
             return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        return ""
    }
    
    var actionButtonConfig:ProfileHeadeActionButtonConfig{
        if user.isCurrentUser{
            return .editProfile
        } else {
            return .followAndUnfollow
        }
    }
    
//MARK: - Lifecycle
    
    init(user:User) {
        self.user = user
    }
    
    
    
}
