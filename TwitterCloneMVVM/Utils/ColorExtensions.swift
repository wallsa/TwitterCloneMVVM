//
//  ColorExtensions.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//


import UIKit

extension UIColor{
    
    static func rgb(red: CGFloat, green : CGFloat, blue:CGFloat) -> UIColor{
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
    static let twitterBlue = UIColor.rgb(red: 29, green: 161, blue: 242)
   
}
