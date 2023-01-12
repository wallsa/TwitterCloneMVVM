//
//  ProfileFilterView.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 09/01/23.
//

import UIKit

private let reusableIdentifier = "reusableIdentifier"


protocol ProfileFilterViewDelegate:AnyObject {
    func filterView(_ view: ProfileFilterView, didSelect indexPath:IndexPath)
}

class ProfileFilterView : UIView {
    
//MARK: - Properties
    
    weak var delegate:ProfileFilterViewDelegate?
    
    lazy var collectionView : UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - API

//MARK: - Helper Functions
    
    func configureUI(){
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        
        //Selecionar inicialmente a primeira opcao
        let firstOption = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: firstOption, animated: true, scrollPosition: .left)
    }

//MARK: - Selectors
    
}
//MARK: - Collection View Dimensions
extension ProfileFilterView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(Int(ProfileFilterOptions.allCases.count)), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - Collection View Data Source and Delegate

extension ProfileFilterView:UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! ProfileFilterCell
        cell.option = ProfileFilterOptions(rawValue: indexPath.row) ?? .tweets
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, didSelect: indexPath)
    }
    
    
    
}
