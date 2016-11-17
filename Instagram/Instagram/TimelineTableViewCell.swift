//
//  TableViewCell.swift
//  Instagram
//
//  Created by ALLAN CHAI on 15/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    @IBOutlet weak var ContentImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var ContextLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
  
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
   
    @IBOutlet weak var usenameLabel: UILabel!
    
    // Declare TimelineTableView Cell Delegate
    var delegate: TimelineTableViewCellDelegate?
    
    
/*-------------------like Button--------------*/
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            likeButton.addTarget(self, action: #selector(onLikeButtonPressed), for: .touchUpInside)
        }
    }
    
    func onLikeButtonPressed(button: UIButton) {
        
    }
/*------------------Comment Button-------------*/
    @IBOutlet weak var commentButton: UIButton! {
        didSet {
            commentButton.addTarget(self, action: #selector(onCommentButtonPressed), for: .touchUpInside)
        }
        
    }
    
    func onCommentButtonPressed(button: UIButton) {
        
    }
/*--------------Share Button-------------------*/
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.addTarget(self, action: #selector(onShareButtonPressed), for: .touchUpInside)
        }
    }
    
    func onShareButtonPressed(button: UIButton) {
        
    }
/*---------------------------------------------*/
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        commentLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target:self,action:#selector(self.onCommentLabelPressed(sender:)))
        commentLabel.addGestureRecognizer(tap)
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onCommentLabelPressed(sender: UITapGestureRecognizer){
        delegate?.timelineCellOnCommentPressed(cell: self)
    }

}

//TimelineTableView Cell Delegate
protocol TimelineTableViewCellDelegate {
    
    func timelineCellOnCommentPressed(cell : TimelineTableViewCell)
}


