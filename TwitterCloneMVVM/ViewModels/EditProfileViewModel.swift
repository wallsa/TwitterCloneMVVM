//
//  EditProfileViewModel.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 28/01/23.
//

import UIKit

enum EditProfileOptions:Int, CaseIterable{
    case fullname
    case username
    case bio
    
    var description:String {
        switch self{
        case .fullname: return "Name"
        case .username:return "Username"
        case .bio:return "Biography"
        }
    }
}

struct EditProfileViewModel{
    
    private let user:User
    let option : EditProfileOptions
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
    
    var shouldHideTextField:Bool{
        return option == .bio
    }
    
    var shouldHideTextView:Bool{
        return option != .bio
    }
    
    var optionValue:String?{
        switch option {
        case .fullname: return user.fullname
        case .username: return user.username
        case .bio: return user.bio
        }
    }
    
    var titleText:String{
        return option.description
    }
    
    var shouldHidePlaceHolder:Bool{
        return user.bio != nil
    }
    
    
    
}
