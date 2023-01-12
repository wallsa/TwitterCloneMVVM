//
//  ExploreController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit

private let reusableIdentifier = "reusableIdentifier"

class ExploreController: UITableViewController {
    

//MARK: - Properties
    var users:[User]?{
        didSet{tableView.reloadData()}
    }
    
    var filteredUsers:[User]?{
        didSet{tableView.reloadData()}
    }
    
    var inSearchMode:Bool{
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)

//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
        configureSearchController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.isNavigationBarHidden = false
    }
    
//MARK: - Helper Functions
    
    func configureUI(){
        configureTableView()
        view.backgroundColor = .white
        navigationItem.title = Constants.NavBar.searchTitle
    }
    
    func configureTableView(){
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.register(UserCell.self, forCellReuseIdentifier: reusableIdentifier)
    }
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
//MARK: - API
    
    func fetchUsers(){
        UserService.shared.fetchUsers { users in
            print("DEBUG: users are \(users)")
            self.users = users
        }
    }
    
}

//MARK: - TableView DataSource And delegate
extension ExploreController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers?.count ?? 0 : users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers?[indexPath.row] : users?[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = inSearchMode ? filteredUsers?[indexPath.row] : users?[indexPath.row] else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: -  Search Controller - UISearchResultsUpdating

extension ExploreController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filteredUsers = users?.filter({$0.username.contains(searchText)})
    }
    
    
}
