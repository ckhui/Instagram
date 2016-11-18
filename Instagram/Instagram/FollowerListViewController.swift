//
//  UserListViewController.swift
//  Instagram
//
//  Created by NEXTAcademy on 11/18/16.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FollowerListViewController: UIViewController {
    
    //input array of uid
    var uidArray = [String]()
    
    var frDBref : FIRDatabaseReference!
    var followers : [Follower] = []
    var followingUid : [String] = []
    let masteruid = Instagram().currentUserUid()
    var index = -1
    
    @IBOutlet weak var userListTableView: UITableView!{
        didSet{
            userListTableView.delegate = self
            userListTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frDBref = FIRDatabase.database().reference()
        loadUserList()
    }
    
    func loadUserList(){
        frDBref.child("User").observe(.value, with: {(snapshot) in

            guard let userDict = snapshot.value as? [String : AnyObject]
                else
            {
                return
            }
            
            for eachUser in userDict{
                if self.uidArray.index(of: eachUser.key) != nil{
                    let newUser = Follower()
                    
                    if let userDetail = eachUser.value as? [String : AnyObject]{
                        let name = userDetail["name"] as! String
                        let picUrl = userDetail["picture"] as! String
                        let userUid = eachUser.key
                        
                        newUser.name = name
                        newUser.picture = picUrl
                        newUser.uid = userUid
                        
                        self.followers.append(newUser)
                    }
                }
            }
            //self.userListTableView.reloadData()
            self.fetchFollwing()
        })
    }
    
    func fetchFollwing(){
        frDBref.child("Following/\(self.masteruid)").observe(.value, with: {(snapshot) in
            
            guard let followingUsers = snapshot.value as? [String : AnyObject]
                else
            {
                return
            }
            
            self.followingUid = Array(followingUsers.keys)
            
            self.finishFetchData()
        })
    }
    
    func finishFetchData(){
        for eachuser in followers {
            let uid = eachuser.uid
            if followingUid.index(of: uid) != nil{
                eachuser.isFollow = true
            }
        }
        
        userListTableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "followerPageToProfilePage") {
            let destination = segue.destination as! ProfileCollectionViewController
            destination.profilelUid = followers[index].uid
        }
    }
    
    
}

extension FollowerListViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "followerCell", for: indexPath) as! FollowerCell
        
        let tempUser = followers[indexPath.row]
        
        cell.imgView.loadImageUsingCacheWithUrlString(tempUser.picture)
        cell.nameLabel.text = tempUser.name
        
        if tempUser.isFollow {
            cell.button.setFollowing()
        }
        else{
            cell.button.setFollow()
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "followerPageToProfilePage", sender: self)
        
    }
}

extension FollowerListViewController : FollowerCellDelegate{
    func followerCellButtonTapped(cell: FollowerCell) {
        guard let indexPath = userListTableView.indexPath(for: cell)
            else{
                return
        }
        
        let user = followers[indexPath.row]
        
        if user.isFollow{
            //unfollow
            Instagram().instagramAction(type: .unfollow, targetUid: user.uid)
        }
        else{
            //follow
            Instagram().instagramAction(type: .follow, targetUid: user.uid)
        }
        
        user.isFollow = !user.isFollow
        
        userListTableView.reloadRows(at: [indexPath], with: .fade)

    }
}
