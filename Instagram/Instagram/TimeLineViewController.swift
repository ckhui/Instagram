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
    var indexToSend = -1
    let currentUserUid = Instagram().currentUserUid()
    
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
    
    func fetcingData(completion:(_ :Bool)->()){
        
    }
    
    
    /*----------------- Prepare Segue --------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "commentSegue") {
            let destination = segue.destination as! CommentViewController
            destination.insta = instras[indexToSend]
        }
        else if (segue.identifier == "userNameToProfile") {
            let destination = segue.destination as! ProfileCollectionViewController
            destination.profilelUid = instras[indexToSend].posterID
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
                
                if instraDictionary.index(forKey: "likeby") != nil {
                    let postlike = instraDictionary["likeby"] as? [String :String]
                    for liker in (postlike?.keys)!{
                        newInsta.like.append(liker)
                    }
                    
                    if newInsta.like.index(of: self.currentUserUid) != nil{
                        newInsta.isLiked = true
                    }
                    
                }
                newInsta.profilePictureURL = userDictionary["picture"] as! String?
                
                self.instras.append(newInsta)
                self.timelineTableView.reloadData()
                
            })
        })
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
        
        
        //print(insta.posterID)
        timerlineCell.usenameLabel.text = insta.username
        timerlineCell.ContextLabel.text =  insta.postDetail!
        //timerlineCell.TimeLabel.text = insta.postTime
        timerlineCell.commentLabel.text = "view 13 commments"
        
        let likeCount = insta.like.count
        if (likeCount == 0) {
            timerlineCell.likeLabel.isHidden = true
        }
        else if (likeCount == 1) {
            timerlineCell.likeLabel.isHidden = false
            timerlineCell.likeLabel.text = "❤️ \(likeCount) like"
            
        } else {
            timerlineCell.likeLabel.isHidden = false
            timerlineCell.likeLabel.text = "❤️ \(likeCount) likes"
        }
        
        if insta.isLiked {
            timerlineCell.likeButton.setImage(#imageLiteral(resourceName: "redheart"), for: .normal)
        }
        else{
            timerlineCell.likeButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        }
        
        timerlineCell.profileImage.roundShape()
        timerlineCell.profileImage.loadImageUsingCacheWithUrlString(insta.profilePictureURL!)
    
        timerlineCell.ContentImage.loadImageUsingCacheWithUrlString(insta.postImageURL!)
        
        // set timerline cell delegate
        timerlineCell.selectionStyle = UITableViewCellSelectionStyle.none
        timerlineCell.delegate = self
        return timerlineCell
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
    
    func timelineCellOnLikeButtonPressed(cell: TimelineTableViewCell) {
        guard let indexPath = timelineTableView.indexPath(for: cell)
            else{
                return
        }
        
        let clickedPost = instras[indexPath.row]
        clickedPost.isLiked = !(clickedPost.isLiked)
        
        
        if clickedPost.isLiked {
            //+like
            clickedPost.like.append(currentUserUid)
            Instagram().instagramAction(type: .like, targetUid: clickedPost.imageUid)
        }
        else{
            //-like
            if let index = clickedPost.like.index(of: currentUserUid){
                clickedPost.like.remove(at: index)
            }
            Instagram().instagramAction(type: .unlike, targetUid: clickedPost.imageUid)
        }
        
        // TODO : fix auto scroll to top after reload
        timelineTableView.reloadRows(at: [indexPath], with: .none)

    }
    
    func timelineCellOnNameLabelPressed(cell: TimelineTableViewCell) {
        //segue to profile page
        guard let indexPath = timelineTableView.indexPath(for: cell)
            else{
                return
        }
        indexToSend = indexPath.row
        
        self.performSegue(withIdentifier: "userNameToProfile", sender: self)
        
    }
}



