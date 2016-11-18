//
//  FollowerCell.swift
//  Instagram
//
//  Created by NEXTAcademy on 11/18/16.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class FollowerCell: UITableViewCell {

    var delegate: FollowerCellDelegate?
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var button: UIButton!{
        didSet{
            button.addTarget(self, action: #selector(onButtonPressed(button:)), for: .touchUpInside)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onButtonPressed(button : UIButton){
        delegate?.followerCellButtonTapped(cell: self)
    }

}

protocol FollowerCellDelegate {
    func followerCellButtonTapped(cell : FollowerCell)
}
