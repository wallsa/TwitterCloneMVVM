//
//  User.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 03/01/23.
//

import Foundation
import Firebase


struct User {
    var fullname:String
    var username:String
    var profileImageUrl:URL?
    let email:String
    let uid:String
    var stats:UserRelationsStats?
    var bio:String?
    
    
    var isFollowed:Bool = false
    
    var isCurrentUser:Bool{return Auth.auth().currentUser?.uid == uid}
    
    init(uid:String, dataDictionary:[String:Any]){
        self.uid = uid
        self.fullname = dataDictionary["fullname"] as? String ?? ""
        self.username = dataDictionary["username"] as? String ?? ""
        self.email = dataDictionary["email"] as? String ?? ""
        
        if let bio = dataDictionary["bio"] as? String{
            self.bio = bio
        }
        if let urlString = dataDictionary["profileImageUrl"] as? String {
            if let url = URL(string: urlString){
                self.profileImageUrl = url
            }
        }
    }
}

struct UserRelationsStats {
    var followers:Int
    var following:Int
}
