//
//  Service.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 20/12/22.
//

import UIKit
import Firebase

//MARK: - Referencias
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DATA_REF = Database.database().reference()
let REF_USERS = DATA_REF.child("users")
let REF_TWEETS = DATA_REF.child("tweets")
let REF_USER_TWEETS = DATA_REF.child("user-tweets")

struct AuthCredentials{
    let email:String
    let fullname:String
    let username:String
    let password:String
    let profileImage:UIImage
}


struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email:String, password:String, authCompletion:@escaping (AuthDataResult?, Error?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password, completion: authCompletion)
    }
    
    
    func registerUser(withCredentials credentials:AuthCredentials, databaseCompletion:@escaping (Error?, DatabaseReference) -> (), authCompletion:@escaping (Error?) -> ()){
        let email = credentials.email
        let fullname = credentials.fullname
        let password = credentials.password
        let username = credentials.username
        let profileImage = credentials.profileImage
        //Salvando a nossa imagem no storage da Firebase e dentro do clousure, temos acesso ao URL da imagem, dado que salvamos em nossa database
        let fileName = NSUUID().uuidString
        let imageStorageRef = STORAGE_PROFILE_IMAGES.child(fileName)
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        imageStorageRef.putData(imageData, metadata: nil) { meta , error  in
            imageStorageRef.downloadURL { url , error in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: email, password: password) { result , error in
                    if let error = error{
                        authCompletion(error)
                }
                    guard let uid = result?.user.uid else {return}
                    let values = ["email" : email, "username" : username, "fullname" : fullname, "password" : password, "profileImageUrl" : profileImageUrl]
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: databaseCompletion)
                    }
                }
            }
        }
    
    
}
