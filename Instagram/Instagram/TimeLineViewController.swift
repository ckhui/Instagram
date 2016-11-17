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
    var likeDBref : FIRDatabaseReference!
    var instras : [Insta] = []
    var img :[String] = []
    var indexToSend = -1
    
    /*--------------------view Did Load--------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegate and datasource
        self.timelineTableView.dataSource = self
        self.timelineTableView.delegate = self
        
        //firebase reference
        frDBref = FIRDatabase.database().reference()
        likeDBref = FIRDatabase.database().reference()
        
        fetchInsta()
        
        // table view UI setting
        timelineTableView.tableFooterView = UIView()
        timelineTableView.rowHeight = UITableViewAutomaticDimension
        timelineTableView.estimatedRowHeight = 99.0
        
    }
    
    
    
    
    /*----------------- Prepare Segue --------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "commentSegue") {
            let destination = segue.destination as! CommentViewController
            destination.insta = instras[indexToSend]
            
        }
    }
    
    
    /*----------------- Fetch the data --------------------*/
    func fetchInsta() {
        
        frDBref.child("ImagePost").observe(.childAdded, with: {(snapshot) in
            let newInsta = Insta()
            guard let instaId = snapshot.key as? String
                else {
                    return
            }
            
            guard let instraDictionary = snapshot.value as? [String : AnyObject]
                else
            {
                return
            }
            
            let imageUid = instaId
            let posterID = instraDictionary["poster"] as? String
            let postImageURL = instraDictionary["url"] as? String
            let postDetail = instraDictionary["desc"] as? String
            let postlike = instraDictionary["likeby"] as? [String:String]
            
            
            //newInsta.postTime = instraDictionary["timestamp"] as? String
            //newInsta.like = instraDictionary["likeby"] as? String
            //  postlike?.count
            
            
            
            
            
            self.frDBref.child("User").child(posterID!).observe(.value, with: { (userSnapshot) in
                guard let userDictionary = userSnapshot.value as? [String:AnyObject]
                    else {
                        
                        return
                }
                newInsta.imageUid = imageUid
                newInsta.posterID = posterID
                newInsta.postImageURL = postImageURL
                newInsta.postDetail = postDetail
                newInsta.username = userDictionary["name"] as! String?
                newInsta.like = (postlike?.count)!
                newInsta.profilePictureURL = userDictionary["picture"] as! String?
                self.instras.append(newInsta)
                self.timelineTableView.reloadData()
                
            })
        })
    }
    
    func fetchName() {
        frDBref.child("User").observe(.childAdded, with: {(snapshot) in
            let newUser = User()
            guard let NameDictionary = snapshot.value  as? [String: AnyObject] else
            {
                return
            }
            
            newUser.name = NameDictionary["name"] as? String
            print(newUser.name)
        })
    }
    
}




/*-------------Timeline Table Cell Delegate ---------*/
extension TimeLineViewController: TimelineTableViewCellDelegate {
    func timelineCellOnCommentPressed(cell: TimelineTableViewCell) {
        guard let indexPath = timelineTableView.indexPath(for: cell)
            else{
                return
        }
        indexToSend = indexPath.row
        
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
        
        
        print(insta.posterID)
        timerlineCell.usenameLabel.text = insta.username
        timerlineCell.ContextLabel.text =  insta.postDetail!
        //timerlineCell.TimeLabel.text = insta.postTime
        timerlineCell.commentLabel.text = "view 13 commments"
        
        if (insta.like == 0) {
            timerlineCell.likeLabel.isHidden = true
        }
        else if (insta.like == 1) {
            timerlineCell.likeLabel.isHidden = false
            timerlineCell.likeLabel.text = "❤️ \(insta.like) like"
            
        } else {
            timerlineCell.likeLabel.isHidden = false
            timerlineCell.likeLabel.text = "❤️ \(insta.like) likes"
        }
        
        
        
        circularImage(image: timerlineCell.profileImage)
        let data1 = NSData(contentsOf: NSURL(string: insta.profilePictureURL!)! as URL)
        timerlineCell.profileImage.image = UIImage(data: data1 as! Data)
        
        
        //get image from url
        // download image from firebase
        let data = NSData(contentsOf: NSURL(string: insta.postImageURL!)! as URL)
        timerlineCell.ContentImage.image = UIImage(data: data as! Data)
        
        //  timerlineCell.ContentImage.image = UIImage(named: "pichu")
        
        // set timerline cell delegate
        timerlineCell.delegate = self
        return timerlineCell
    }
    
    func circularImage(image : UIImageView) {
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.shadowOpacity = 0.7
        image.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        image.layer.shadowRadius = 5
        image.layer.shadowColor = UIColor.black.cgColor
    }
    
}




