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
}
