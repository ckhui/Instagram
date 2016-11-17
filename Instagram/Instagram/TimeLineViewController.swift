//
//  TimeLineViewController.swift
//  Instagram
//
//  Created by ALLAN CHAI on 15/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class TimeLineViewController: UIViewController, UITableViewDelegate {

/*--------------declaration variable-------------------*/
    
    @IBOutlet weak var timelineTableView: UITableView!
    // declare firebase reference
    var frDBref : FIRDatabaseReference!
    var instras : [Insta] = []
    var img :[String] = []
    
/*--------------------view Did Load--------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //set delegate and datasource
        self.timelineTableView.dataSource = self
        self.timelineTableView.delegate = self
        
        //firebase reference
        frDBref = FIRDatabase.database().reference()
        
        fetchInsta()
        
        // table view UI setting
        timelineTableView.tableFooterView = UIView()
        timelineTableView.rowHeight = UITableViewAutomaticDimension
        timelineTableView.estimatedRowHeight = 99.0
        
    }
    
    
    
    
/*----------------- Prepare Segue --------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "commentSegue") {
    
            guard let selectedIndexPath : IndexPath = timelineTableView.indexPathForSelectedRow else {
        
      
                return
            }
   
            let controller : CommentViewController = segue.destination as!
            CommentViewController
       
        }
    }
    
    
/*----------------- Fetch the data --------------------*/
    func fetchInsta() {
       
        frDBref.child("ImagePost").observe(.childAdded, with: {(snapshot) in
            let newInsta = Insta()
            guard let instraDictionary = snapshot.value as?
            [String : AnyObject]
            else
        {
            return
        }
            newInsta.posterID = instraDictionary["poster"] as? String
            newInsta.postImageURL = instraDictionary["url"] as? String
            newInsta.postDetail = instraDictionary["desc"] as? String
            //newInsta.postTime = instraDictionary["timestamp"] as? String
          //  newInsta.like = instraDictionary["likeby"] as? String
            
            self.instras.append(newInsta)
            self.timelineTableView.reloadData()
        })
    }

    func fetchName() {
        frDBref.child("user").observe(.childAdded, with: {(snapshot) in
             let newUser = User()
            guard let NameDictionary = snapshot.value  as? [String: AnyObject] else
            {
                return
            }
            
            newUser.name = NameDictionary["name"] as? String
        })
    }

}




/*-------------Timeline Table Cell Delegate ---------*/
extension TimeLineViewController: TimelineTableViewCellDelegate {
    func sendInfoToCommentSegue() {
        self.performSegue(withIdentifier: "commentSegue", sender: self)
    }
 }

/*-------------Table View Data Source---------------*/
extension TimeLineViewController: UITableViewDataSource {
    
    //set number of row in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instras.count
    }
    
    //cell for row at index Path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let timerlineCell : TimelineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as? TimelineTableViewCell else {
            return UITableViewCell()
        }
        let insta = instras[indexPath.row]
        
        timerlineCell.profileImage.image = UIImage(named:"pichu")
        
        print(insta.posterID)
        timerlineCell.usenameLabel.text = "Huan Huan"
        timerlineCell.ContextLabel.text =  insta.postDetail!
        //timerlineCell.TimeLabel.text = insta.postTime
        timerlineCell.commentLabel.text = "view 13 commments"
        timerlineCell.likeLabel.text = "❤️ 100 likes"
        //print(insta.like)
    
       
        //get image from url
        // download image from firebase
        let data = NSData(contentsOf: NSURL(string: insta.postImageURL!)! as URL)
        timerlineCell.ContentImage.image = UIImage(data: data as! Data)
     
        //  timerlineCell.ContentImage.image = UIImage(named: "pichu")
        
        // set timerline cell delegate
        timerlineCell.delegate = self
        return timerlineCell
    }

}


