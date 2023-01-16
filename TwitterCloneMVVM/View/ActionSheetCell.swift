//
//  ActionSheetCell.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 15/01/23.
//

import UIKit

class ActionSheetCell:UITableViewCell{

    
//MARK: - Properties
    
    var option:ActionSheetOptions?{
        didSet{configure()}
    }
    
    private let optionImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(imageLiteralResourceName: Constants.NavBar.twitterLogo)
        return imageView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Testando a label"
        return label
    }()

//MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - API

//MARK: - Helper Functions
    
    func configureUIElements(){
        addSubview(optionImageView)
        optionImageView.centerY(inview: self)
        optionImageView.anchor(left: leftAnchor, paddingLeft: 8, width: 36, height: 36)
        
        addSubview(titleLabel)
        titleLabel.centerY(inview: self)
        titleLabel.anchor(left: optionImageView.rightAnchor, paddingLeft: 12)
    }
    
    func configure(){
        titleLabel.text = option?.description
    }

//MARK: - Selectors
    
}
