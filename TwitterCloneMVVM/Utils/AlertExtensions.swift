//
//  AlertExtensions.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 14/02/23.
//

import UIKit

extension UIAlertController{
    func createSimpleAlert(title:String, message:String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        return alert
    }
    
    func createLogoutAlert(completion: @escaping (UIAlertAction) -> ()) -> UIAlertController{
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: completion))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }
}
