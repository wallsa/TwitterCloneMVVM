//
//  SignupController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit
import Firebase

class SignupController: UIViewController {

//MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage : UIImage?
    
    private let profilePhotoView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        return view
    }()
    
    private let addPhotoButton : UIButton = {
        let button = UIButton()
        button.setImage(.add, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddImage), for: .touchUpInside)
        return button
    }()
    
    private lazy var fullNameContainerView : UIView = {
        return UIView().createContainerView(image: Constants.LoginAndSignupImages.personImage, textfield: fullNameTextField)
    }()
    
    private lazy var userNameContainerView : UIView = {
        return UIView().createContainerView(image: Constants.LoginAndSignupImages.personImage, textfield: userNameTextField)
    }()
    
    private lazy var emailContainerView : UIView = {
        return UIView().createContainerView(image: Constants.LoginAndSignupImages.emailImage, textfield: emailTextField)
    }()
    
    private lazy var passwordContainerView : UIView = {
        return UIView().createContainerView(image: Constants.LoginAndSignupImages.passwordImage, textfield: passwordTextField)
    }()
    
    private let fullNameTextField : UITextField = {
        return UITextField().createSimpleTextField(placeholder: "Full Name", isSecure: false)
    }()
    
    private let userNameTextField : UITextField = {
        return UITextField().createSimpleTextField(placeholder: "User Name", isSecure: false)
    }()
    
    private let emailTextField : UITextField = {
        return UITextField().createSimpleTextField(placeholder: "Email", isSecure: false)
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().createSimpleTextField(placeholder: "Password", isSecure: true)
    }()
    
    private let signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
        }()
    
    
    
//MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setDelegates()
    }
    
//MARK: - Helper Functions
    
    
    func configureUI(){
        view.backgroundColor = .twitterBlue
        view.addSubview(profilePhotoView)
        profilePhotoView.centerX(inview: view)
        profilePhotoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        profilePhotoView.setDimensions(height: 120, width: 120)
        profilePhotoView.layer.cornerRadius = 120 / 2
        
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(bottom: profilePhotoView.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 120, width: 30, height: 30)
        addPhotoButton.layer.cornerRadius =  30 / 2
        
        let stack = UIStackView(arrangedSubviews: [fullNameContainerView, userNameContainerView, emailContainerView, passwordContainerView])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 8
        
        view.addSubview(stack)
        stack.anchor(top: profilePhotoView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(signupButton)
        signupButton.anchor(top: stack.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16, height: 50)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        
        
    }
    
//MARK: - Selectors
   
    @objc func handleSignup(){
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image")
            return
        }
        guard let email = emailTextField.text else {return}
        guard let username = userNameTextField.text?.lowercased() else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        let credentials = AuthCredentials(email: email, fullname: fullname, username: username, password: password, profileImage: profileImage)
        
        AuthService.shared.registerUser(withCredentials: credentials) { error , databaseref in
            if let error = error {
                print("DEBUG: Error in database \(error.localizedDescription)")
            }
            //Dismiss VC e seguir com o fluxo
            print("DEBUG: The user is sucessfully updated")
            let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first

            if let mainTab = keyWindow?.rootViewController as? MainTabController { mainTab.authenticateUserAndConfigureUI()}
            self.dismiss(animated: true, completion: nil)
            
        } authCompletion: { error in
            //FIXME: - Apresentar o erro ao usuario
            print("DEBUG: The error in authentication is \(error?.localizedDescription)")
        }

       
    }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAddImage(){
        present(imagePicker, animated: true)
    }
}

//MARK: - Delegates

extension SignupController : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func setDelegates(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        
        self.profileImage = profileImage
        profilePhotoView.layer.masksToBounds = true

        profilePhotoView.layer.borderColor = UIColor.white.cgColor
        profilePhotoView.layer.borderWidth = 3

        profilePhotoView.image = profileImage
        
        
        dismiss(animated: true)
    }
}
