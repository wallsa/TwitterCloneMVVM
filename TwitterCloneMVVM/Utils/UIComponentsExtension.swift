//
//  UIComponentsExtension.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 19/12/22.
//

import UIKit

extension UIView{
    func createContainerView(image: String, textfield:UITextField) -> UIView{
        let view = UIView()
        let imageView = UIImageView()
        let image = UIImage(imageLiteralResourceName: image)
        imageView.image = image
        
        view.addSubview(imageView)
        imageView.centerY(inview: view)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
        
        view.addSubview(textfield)
        textfield.centerY(inview: view)
        textfield.anchor(left: imageView.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .white
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 0.75)
        view.anchor(height: 50)
        return view
    }
}

extension UITextField {
    func createSimpleTextField(placeholder:String, isSecure:Bool) -> UITextField{
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .white
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = .emailAddress
        textField.keyboardAppearance = .dark
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return textField
    }
}

extension UIButton {
    func createTweetCellButton(withImage image:String, selectorName:Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(imageLiteralResourceName: image), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self , action: selectorName, for: .touchUpInside)
        button.setDimensions(height: 20, width: 20)
        return button
    }
}

extension NSAttributedString{
    func attributedText(withValue value:Int, text:String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
    
    func attributedText(withBoldText text:String, andText text2:String) -> NSAttributedString{
        let title = NSMutableAttributedString(string: text, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let name = NSAttributedString(string: " @\(text2)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        
        title.append(name)
        return title
    }
    
    func notificationAttributedText(userBoldText text1:String, notificationType text2:String, timeStamp text3:String) -> NSAttributedString{
        let title = NSMutableAttributedString(string: text1, attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
        let name = NSAttributedString(string: " \(text2)", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.black])
        let timestamp = NSAttributedString(string: " - \(text3)", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray])
        
        title.append(name)
        title.append(timestamp)
        return title
    }
}

extension UINavigationController{
    func templateNavController(image: UIImage? = nil, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        return nav
    }
}
