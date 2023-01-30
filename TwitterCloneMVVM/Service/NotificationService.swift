//
//  NotificationService.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 19/01/23.
//

import Firebase


struct NotificationService{
    
    static let shared = NotificationService()
    
    
    func uploadNotification(toUser user:User, type:NotificationType, tweetID:String? = nil){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var values:[String:Any] = ["timestamp" : Int(NSDate().timeIntervalSince1970), "uid" : uid, "type" : type.rawValue]
        
        switch type {
        case .follow:
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
            
        case .reply:
            guard uid != user.uid else {return}
            values["tweetID"] = tweetID
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
            
        case .like:
            guard uid != user.uid else {return}
            values["tweetID"] = tweetID
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
            
        case .retweet:
            print("Retweet")
            break
            
        case .mention:
            break
        }
    }
    
    func fetchNotifications(completion:@escaping([Notification]) -> ()){
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { datasnap in
            guard let dictionary = datasnap.value as? [String:Any] else {return}
            guard let userID = dictionary["uid"] as? String else {return}
            
                UserService.shared.fetchUser(uid: userID) { user in
                    let notification = Notification(user: user, dictionary: dictionary)
                    notifications.append(notification)
                    completion(notifications)
                }
                        
        }
    }
    
    
}
