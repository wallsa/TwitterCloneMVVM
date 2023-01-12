//
//  UserService.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 03/01/23.
//

import Firebase


typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

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
    
    func followUser(uid:String, completion:@escaping(DatabaseCompletion)){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUID).updateChildValues([uid:1]) { error , dataref in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUID:1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid:String, completion:@escaping(DatabaseCompletion)){
        
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUID).child(uid).removeValue { _, _ in
            REF_USER_FOLLOWERS.child(uid).child(currentUID).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid:String, completion:@escaping(Bool) -> ()){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        REF_USER_FOLLOWING.child(currentUID).child(uid).observeSingleEvent(of: .value) { datasnap in
            completion(datasnap.exists())
        }
    }
    
    func fetchUserStats(uid:String, completion:@escaping (UserRelationsStats) -> ()){
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { datasnap in
            let followers = datasnap.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { datasnap in
                let following = datasnap.children.allObjects.count
                
                let stats = UserRelationsStats(followers: followers, following: following)
                
                completion(stats)
            }
        }
    }
}
