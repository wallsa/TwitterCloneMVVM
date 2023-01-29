//
//  EditProfileController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 28/01/23.
//

import UIKit

protocol EditProfileControllerDelegate:AnyObject{
    func controller(_ controller:EditProfileController, wantsToUpdate user:User)
}

private let reusableIdentifier = "EditProfileCell"

class EditProfileController:UITableViewController{
    
//MARK: - Properties
    
    private var user:User
    
    weak var delegate:EditProfileControllerDelegate?
    
    private lazy var header = EditProfileHeader(user: user)
    private let imagePicker = UIImagePickerController()
    
    private var userInfoChange = false
    private var userImageChange:Bool{
        return pickedImage != nil
    }
    
    private var pickedImage : UIImage?{
        didSet{header.userProfileImage.image = pickedImage}
    }

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationbar()
        configureTableView()
        configureImagePicker()
    }
    
    init(user:User){
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
//MARK: - Helper Functions
    
    func configureNavigationbar(){
        navigationController?.navigationBar.barTintColor = UIColor.twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target:self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target:self, action: #selector(handleDone))
        
        
    }
    
    func configureTableView(){
        
        tableView.tableHeaderView = header
        header.delegate = self
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reusableIdentifier)
    }
    
    func configureImagePicker(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
//MARK: - API
        
    func updateUserData(){
        if userInfoChange && userImageChange{
            print("DEBUG: Change image and Data")
            UserService.shared.saveUserData(user: user) { error , dataref in
                self.updateProfileImage()
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
        
        if userInfoChange && !userImageChange{
            print("DEBUG: Change Data")
            UserService.shared.saveUserData(user: user) { error , dataref in
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
        
        if !userInfoChange && userImageChange{
            print("DEBUG: Change Image")
            self.updateProfileImage()
            self.delegate?.controller(self, wantsToUpdate: self.user)
            
        }
    }
    
    func updateProfileImage(){
        guard let image = pickedImage else {return}
        UserService.shared.updateProfileImage(image: image) { newProfileImageUrl in
            self.user.profileImageUrl = newProfileImageUrl
        }
    }
    

//MARK: - Selectors
    
    @objc func handleCancel(){
        
        dismiss(animated: true)
    }
    
    @objc func handleDone(){
        view.endEditing(true)
        guard userInfoChange || userImageChange else {return}
        updateUserData()
    }
    
}

//MARK: - TableView DataSource and Delegate

extension EditProfileController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! EditProfileCell
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return cell}
        cell.delegate = self
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        return cell
    }
}

extension EditProfileController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let option = EditProfileOptions(rawValue: indexPath.row){
            return option == .bio ? 100 : 48
        }
        return 0
    }
}

//MARK: - EditProfileHeaderDelegate - Image Picker
extension EditProfileController:EditProfileHeaderDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        pickedImage = image
        dismiss(animated: true)
        
    }
}

//MARK: - Edit Profile Cell Delegate

extension EditProfileController:EditProfileCellDelegate{
    
    func userInfoTextChange(_ cell: EditProfileCell) {
        userInfoChange = true
        
        guard let option = cell.viewModel?.option else {return}
        
        switch option {
        case .fullname:
            guard let updatedFullname = cell.userInfoTextField.text else {return}
            user.fullname = updatedFullname
        case .username:
            guard let updatedUsername = cell.userInfoTextField.text else {return}
            user.username = updatedUsername
        case .bio:
            user.bio = cell.bioTextView.text
        }
        
    }
}
