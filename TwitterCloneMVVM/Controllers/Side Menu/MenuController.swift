//
//  MenuController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 12/02/23.
//

import UIKit

private let reuseIdentifier = "menuCell"

protocol SideMenuDelegate:AnyObject{
    func optionSelected(_ option:SideMenuOptions)
}

enum SideMenuOptions:Int, CaseIterable, CustomStringConvertible{
    case settings
    case logout
    
    var description: String{
        switch self {
        case .settings: return "Settings"
        case .logout: return "Log Out"
        }
    }
    
    var image:String{
        switch self {
        case .settings: return "gear"
        case .logout: return "arrow.left.square"
        }
    }
}

class MenuController:UIViewController{
    
//MARK: - Properties
    
    var user: User
    
    weak var delegate:SideMenuDelegate?
    
    private lazy var menuHeader : SideMenuHeader = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: 200)
        let view = SideMenuHeader(user: user, frame: frame)
        return view
    }()
    
    private let tableView = UITableView()

//MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        tableView.reloadData()
        configureTableView()
    }

//MARK: - API

//MARK: - Helper Functions
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = menuHeader
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }

//MARK: - Selectors
    
}

//MARK: - TableView Methods
extension MenuController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        guard let option = SideMenuOptions(rawValue: indexPath.row) else {return UITableViewCell()}
        content.text = option.description
        content.image = UIImage(systemName: option.image)
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let option = SideMenuOptions(rawValue: indexPath.row) else {return}
        delegate?.optionSelected(option)
    }
    
}
