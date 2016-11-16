//
//  TimeLineViewController.swift
//  Instagram
//
//  Created by ALLAN CHAI on 15/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit


class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var timelineTableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timelineTableView.dataSource = self
        self.timelineTableView.delegate = self
        // Do any additional setup after loading the view.
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let timerlineCell : TimelineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as? TimelineTableViewCell else {
            return UITableViewCell()
        }
        timerlineCell.profileImage.image = UIImage(named:"pichu")
        timerlineCell.usenameLabel.text = "Huan Huan"
        timerlineCell.ContextLabel.text = "This Pichu so cute, I make it as profile picture, love it! love it! love it! love it! love it! love it! love it!"
        timerlineCell.TimeLabel.text = "13mins ago"
        timerlineCell.commentLabel.text = "view 13 commments"
        timerlineCell.likeLabel.text = "❤️ 100 likes"
        timerlineCell.ContentImage.image = UIImage(named: "pichu")
        timerlineCell.delegate = self
        return timerlineCell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "commentSegue") {
    
            guard let selectedIndexPath : IndexPath = timelineTableView.indexPathForSelectedRow else {
        
      
                return
            }
   
            let controller : CommentViewController = segue.destination as!
            CommentViewController
       
        }
    

    }

   
}

extension TimeLineViewController: TimelineTableViewCellDelegate {
    func sendInfoToCommentSegue() {
        self.performSegue(withIdentifier: "commentSegue", sender: self)
    }
 }


