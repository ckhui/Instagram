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
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
   
    @IBOutlet weak var usenameLabel: UILabel!
    
    var delegate: TimelineTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //commentLabel.isEnabled = true
        commentLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target:self,action:#selector(self.onCommentLabelPressed(sender:)))
        commentLabel.addGestureRecognizer(tap)
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onCommentLabelPressed(sender: UITapGestureRecognizer){
        
        delegate?.sendInfoToCommentSegue()
    }

}

protocol TimelineTableViewCellDelegate {
    func sendInfoToCommentSegue()
}


