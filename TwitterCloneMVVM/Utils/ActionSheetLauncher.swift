//
//  ActionSheetLauncher.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 15/01/23.
//

import UIKit

private let reuseIdentifier = "ActionViewCell"

protocol ActionSheetLaucherDelegate:AnyObject{
    func didSelect(option:ActionSheetOptions)
}

class ActionSheetLaucher:NSObject, UITableViewDataSource, UITableViewDelegate{
    
    
//MARK: - Properties
    
    private let user:User
    private var window:UIWindow?
    private let tableView = UITableView()
    private lazy var viewModel = ActionSheetViewModel(user: user)
    weak var delegate:ActionSheetLaucherDelegate?
    
    private lazy var tableViewHeight = CGFloat(viewModel.option.count * 60) + 100
    
    private lazy var blackView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self , action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerView : UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
        cancelButton.layer.cornerRadius = 50 / 2
        cancelButton.centerY(inview: view)
        return view
    }()
    
    
//MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    }
    
//MARK: - API
    
//MARK: - Helper Functions
    
    func show(){

        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        
        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: tableViewHeight)
        showAndDismissSheet(true)
    }
    
    func showAndDismissSheet(_ shouldShow:Bool){
        guard let window = window else {return}
        let yOrigin = shouldShow ? window.frame.height - tableViewHeight : window.frame.height
        let alpha = shouldShow ? 1 : 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .curveEaseInOut) {
            self.tableView.frame.origin.y = yOrigin
            self.blackView.alpha = CGFloat(alpha)
        }
    }
    
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
//MARK: - Selectors
    
    @objc func handleDismiss(){
        showAndDismissSheet(false)
    }
    
//MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.option.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.option[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.option[indexPath.row]
        showAndDismissSheet(false)
        delegate?.didSelect(option: option)
    }
    

    
}
