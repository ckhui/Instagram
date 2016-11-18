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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        //self.searchTextField.delegate = self
        frDBref = FIRDatabase.database().reference()
        
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchTableView.tableHeaderView = searchController.searchBar
        
        
        // table view UI setting
        searchTableView.tableFooterView = UIView()
        searchTableView.rowHeight = UITableViewAutomaticDimension
        searchTableView.estimatedRowHeight = 99.0
        

        
    }
    func filterContentForSearchText(searchText: String)
    {
        users = []
        self.searchTableView.reloadData()
        
        //    var textFieldContent : String?
        //  textFieldContent = textField.text
        
        
        
        frDBref.child("User").queryOrdered(byChild: "name").queryEqual(toValue: searchText).observe(.childAdded, with: {(snapshot) in
            let newUser = User()
            
            guard let userID = snapshot.key as? String else{
                return
            }
            guard let UserDictionary = snapshot.value as? [String : AnyObject] else {
                return
            }
            print(snapshot)
            
            let uid  = userID
            let userName =  UserDictionary["name"] as? String
            let profilePictureURL = UserDictionary["picture"] as? String
            
            newUser.userID = uid
            newUser.name = userName
            newUser.picture = profilePictureURL!
            
            self.users.append(newUser)
            self.searchTableView.reloadData()
            
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
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        
        let user = users[indexPath.row]
        cell.userNameLabel.text =  user.name
        cell.profilePicture.loadImageUsingCacheWithUrlString(user.picture)

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

