//
//  LoginController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit
import Firebase

class LoginController : UIViewController{
    
//MARK: - Properties
    
    private let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(imageLiteralResourceName: Constants.twitterLogo)
        return imageView
    }()
    
    private lazy var emailContainerView: UIView = {
        return UIView().createContainerView(image: Constants.LoginAndSignupImages.emailImage, textfield: emailTextField)
    }()
    
    private lazy var passwordContainerView: UIView = {
        return UIView().createContainerView(image: Constants.LoginAndSignupImages.passwordImage, textfield: passwordTextField)
    }()
    
    private let emailTextField : UITextField = {
        return UITextField().createSimpleTextField(placeholder: "Email", isSecure: false)
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().createSimpleTextField(placeholder: "Password", isSecure: true)
    }()

    private let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Dont have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.addTarget(self, action: #selector(handleShowSignup), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
        }()
    
    
//MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
//MARK: - Helper Functions
    func configureUI(){
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inview: view)
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 24, width: 150, height: 150)
        
        view.addSubview(emailContainerView)
        emailContainerView.centerX(inview: view)
        emailContainerView.anchor(top: logoImageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.centerX(inview: view)
        passwordContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 50)
        
        view.addSubview(loginButton)
        loginButton.centerX(inview: view)
        loginButton.anchor(top: passwordContainerView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16, height: 50)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inview: view)
        dontHaveAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        
    }
    
//MARK: - Selectors
    
    @objc func handleShowSignup(){
        let signupViewController = SignupController()
        navigationController?.pushViewController(signupViewController, animated: true)
    }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { _, error in
            if let error = error {
                //FIXME: - Deal with error and present error to user
                print("DEBUG: Error Loggin in \(error.localizedDescription)")
                return
            }
            print("DEBUG: Sucess loggin user")
            
            
            let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first

            if let controller = keyWindow?.rootViewController as? ContainerController {controller.configure() }
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    
}
