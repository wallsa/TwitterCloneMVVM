//
//  ProfileFilterCell.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 09/01/23.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
//MARK: - Properties
    
    var option:ProfileFilterOptions?{
        didSet{
            titleLabel.text = option?.description
        }
    }
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override var isSelected: Bool{
        didSet{
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }

//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - API

//MARK: - Helper Functions
    
    func configure(){
        addSubview(titleLabel)
        titleLabel.centerX(inview: self)
        titleLabel.centerY(inview: self)
    }

//MARK: - Selectors

}
