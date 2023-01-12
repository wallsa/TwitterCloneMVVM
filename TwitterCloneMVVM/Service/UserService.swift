//
//  UserService.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 03/01/23.
//

import Firebase


struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid:String, completion:@escaping(User) -> ()){
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            let user = User(uid: uid, dataDictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion:@escaping([User]) ->()){
        var users = [User]()
        
        REF_USERS.observe(.childAdded) { datasnap in
            guard let dictionary = datasnap.value as? [String:Any] else {return}
            let uid = datasnap.key
            let user = User(uid: uid, dataDictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
}
