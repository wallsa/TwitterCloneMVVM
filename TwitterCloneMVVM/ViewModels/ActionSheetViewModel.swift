//
//  ActionSheetViewModel.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 15/01/23.
//

import Foundation


enum ActionSheetOptions{

    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String{
        switch self {
        case .follow(let user):return "Follow @\(user.username)"
        case .unfollow(let user):return "Unfollow @\(user.username)"
        case .report:return "Report Tweet"
        case .delete:return "Delete Tweet"
        }
    }
}

struct ActionSheetViewModel {
    
    var option:[ActionSheetOptions]{
        var options = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            options.append(.delete)
        } else {
            let followOption:ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            options.append(followOption)
        }
        
        options.append(.report)
        print("DEBUG: Options are \(options)")
        print("DEBUG: The user is \(user.username)")
        print("DEBUG: The user is \(user.isFollowed)")
        return options
    }
    
    
    private let user : User
    
    init(user: User) {
        self.user = user
    }
    
}
