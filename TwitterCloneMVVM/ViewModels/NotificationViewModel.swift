//
//  NotificationViewModel.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 22/01/23.
//

import Foundation


struct NotificationViewModel{
    
    private let notification:Notification
    private let user:User
    private let type:NotificationType
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
    
    var profileImageUrl: URL?{
        return notification.user.profileImageUrl
    }
    
    var notificationText:NSAttributedString{
        return NSAttributedString().notificationAttributedText(userBoldText: notification.user.username, notificationType: notification.type.description, timeStamp: timeStampString)
    }
    
    var timeStampString:String{
        let formmater = DateComponentsFormatter()
        formmater.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formmater.maximumUnitCount = 1
        formmater.unitsStyle = .brief
        let now = Date()
        return formmater.string(from: notification.timestamp, to: now) ?? ""
    }
    
    var actionButtonTitle:String{
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var shouldHideFollowButton:Bool{
        return type != .follow
    }
}
