//
//  CaptionTextView.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 04/01/23.
//

import UIKit



class InputTextView: UITextView{
    
//MARK: - Properties
    
    
    let placeholderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
//MARK: - Life Cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        //Uma alternativa ao uso do delgate e a funcao respectiva a mudanca do texto
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - Selectors
    
    @objc func handleTextInputChange(){
        placeholderLabel.isHidden = !text.isEmpty
    }
    
}



