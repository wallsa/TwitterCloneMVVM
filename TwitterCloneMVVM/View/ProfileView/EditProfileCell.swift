//
//  EditProfileCell.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 28/01/23.
//

import UIKit

protocol EditProfileCellDelegate:AnyObject{
    func userInfoTextChange(_ cell:EditProfileCell)
}

class EditProfileCell:UITableViewCell{
    
//MARK: - Properties
    
    weak var delegate:EditProfileCellDelegate?
    
    var viewModel:EditProfileViewModel?{
        didSet{configure()}
    }
    
    let defaultInfoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let userInfoTextField : UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.text = "SSSSSS"
        textField.addTarget(self, action: #selector(updateUserInfo), for: .editingDidEnd)
        textField.textColor = .lightGray
        return textField
    }()
    
    let bioTextView : InputTextView = {
        let textView = InputTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .lightGray
        
        textView.placeholderLabel.text = "Bio"
        return textView
    }()
    
//MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Helpers
    
    private func configure(){
        guard let viewModel = viewModel else {return}
        defaultInfoLabel.text = viewModel.titleText
        userInfoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        userInfoTextField.text = viewModel.optionValue
        bioTextView.placeholderLabel.isHidden = viewModel.shouldHidePlaceHolder
        bioTextView.text = viewModel.optionValue
        
        
    }
    
    private func configureUI(){
        selectionStyle = .none
        
        contentView.addSubview(defaultInfoLabel)

        defaultInfoLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 4 , paddingLeft: 16, width: 100)
        
        contentView.addSubview(userInfoTextField)
        userInfoTextField.anchor(top: topAnchor, left: defaultInfoLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
        
        contentView.addSubview(bioTextView)
        bioTextView.anchor(top: topAnchor, left: defaultInfoLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 14, paddingRight: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserInfo), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    
//MARK: - Selectors
    
    @objc func updateUserInfo(){
        print("DEBUG: Text Change")
        delegate?.userInfoTextChange(self)
    }
}


  

