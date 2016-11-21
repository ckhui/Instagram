//
//  SearchViewController.swift
//  Instagram
//
//  Created by ALLAN CHAI on 15/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SearchViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    // @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    var frDBref : FIRDatabaseReference!
    var users : [User] = []
    var filterUsers : [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        //self.searchTextField.delegate = self
        frDBref = FIRDatabase.database().reference()
        
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        //searchTableView.tableHeaderView = searchController.searchBar
        navigationItem.titleView = searchController.searchBar
        
        // table view UI setting
        searchTableView.tableFooterView = UIView()
        searchTableView.rowHeight = UITableViewAutomaticDimension
        searchTableView.estimatedRowHeight = 99.0
        
        self.fetchUser()
    }
    
    func filterContentForSearchText(searchText: String)
    {
        
        filterUsers = []
        
        if searchText == ""{
            filterUsers = users
        }
        else{
            filterUsers = users.filter { user in
                return (user.name?.lowercased().contains(searchText.lowercased()))!
            }
        }
        self.searchTableView.reloadData()
        
    }
    
    func fetchUser() {
        
        
        frDBref.child("User").observe(.childAdded, with: {(snapshot) in
            let newUser = User()
            guard let userID = snapshot.key as? String else{
                return
            }
            guard let UserDictionary = snapshot.value as? [String : AnyObject] else {
                return
            }
            
            let uid  = userID
            let userName =  UserDictionary["name"] as? String
            let profilePictureURL = UserDictionary["picture"] as? String
            let desc = UserDictionary["desc"] as? String
            
            let currentUid : String = Instagram().currentUserUid()
            
            if (currentUid != uid) {
                newUser.userID = uid
                newUser.name = userName
                newUser.picture = profilePictureURL!
                newUser.desc = desc
                
                self.users.append(newUser)
                
            }
            
        })
        
    }
    
    
}
//TableView Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}




/*-------------------------------------------------------*/
//TableView DataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let user: User
        if searchController.isActive && searchController.searchBar.text != ""
        {
            user = filterUsers[indexPath.row]
        }
        else
        {
            user = users[indexPath.row]
        }
        
        cell.userNameLabel.text =  user.name
        cell.descLabel.text = user.desc
        if (user.picture == "") {
            cell.profilePicture.image = #imageLiteral(resourceName: "jigglypuff")
        }
        else {
            cell.profilePicture.loadImageUsingCacheWithUrlString(user.picture)
        }
        
        
        cell.profilePicture.roundShape()
        
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar)
    {
        filterContentForSearchText(searchText: searchBar.text!)
    }
}

extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

