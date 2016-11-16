//
//  NotificationViewController.swift
//  Swiftgram
//
//  Created by NEXTAcademy on 11/15/16.
//  Copyright © 2016 NEXTAcademy. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followingButton: UIButton!{
        didSet{
            followingButton.addTarget(self, action: #selector(followingButtonOnButtonPressed), for: .touchUpInside)
        }
    }
    @IBOutlet weak var youButton: UIButton!{
        didSet{
            youButton.addTarget(self, action: #selector(youButtonOnButtonPressed), for: .touchUpInside)
        }
    }
    
    var booleanForButtons = true


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
       tableView.rowHeight = UITableViewAutomaticDimension
       tableView.estimatedRowHeight = 110

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //MARK: TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if booleanForButtons {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell",
                                                     for: indexPath) as! NotifcationTableViewCell
            cell.notificationLabel.text = "well this is cool random stuff in my brain hmm what do i type now blah blah blah fwefheuwfhiuwwehfuwui ewureu "
            cell.notificationLabel.textColor = UIColor(white: 114/255, alpha: 1)
            cell.userProfileImage.image = #imageLiteral(resourceName: "pichu")
            return cell

        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "followingCell",
                                                     for: indexPath) as! FollowingTableViewCell
            cell.descriptionOnWhatUserLikes.text = "well this is cool random stuff in my brain hmm what do i type now blah blah blah trump is great duded testing another shit type more bitch "
            cell.userProfilePicture.image = #imageLiteral(resourceName: "pichu")
            return cell

        }
        
        
        
        
    }
    
    
    //MARK: - Button Functions
    func followingButtonOnButtonPressed(){
        self.followingButton.titleLabel?.textColor = UIColor(white: 114/255, alpha: 1)
        
        self.booleanForButtons = false
        tableView.reloadData()
    }
    
    func youButtonOnButtonPressed(){
        self.youButton.titleLabel?.textColor = UIColor(white: 114/255, alpha: 1)
        
        self.booleanForButtons = true
        tableView.reloadData()



    }
    
    

}
