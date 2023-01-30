//
//  NotificationsController.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 18/12/22.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {

//MARK: - Properties
    private var notifications = [Notification](){
        didSet{tableView.reloadData()}
    }

//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
//MARK: - Helper Functions
        
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = Constants.NavBar.notificationsTitle
    }
    
    func configureTableView(){
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self , action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func checkIfUserisFollowed(){
        for (index, notification) in self.notifications.enumerated(){
            if case .follow = notification.type{
                let user = notification.user
                
                UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }
    
//MARK: - Selectors
    
    @objc func handleRefresh(){
        fetchNotifications()
    }
    
//MARK: - API
    
    func fetchNotifications(){
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications.sorted(by: {$0.timestamp > $1.timestamp})
            self.checkIfUserisFollowed()
            self.refreshControl?.endRefreshing()
        }
    }
}

//MARK: - TableView DataSource

extension NotificationsController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

//MARK: - TableView Delegate
extension NotificationsController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        let notification = notifications[indexPath.row]
        guard let tweetId = notification.tweetID else {return}
        TweetService.shared.fetchTweet(forTweetId: tweetId) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - Notification Cell Delegate

extension NotificationsController:NotificationCellDelegate{
    
    func followButtonTapped(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        if user.isFollowed{
            UserService.shared.unfollowUser(uid: user.uid) { error , dataref in
                if let error = error {
                    print("DEBUG: Please try again later... \(error.localizedDescription)")
                }
                cell.notification?.user.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error , dataref in
                if let error = error {
                    print("DEBUG: Please try again later... \(error.localizedDescription)")
                }
                cell.notification?.user.isFollowed = true
            }
        }
    }
    
    func userImageTapped(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
