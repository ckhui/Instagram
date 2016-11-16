//
//  CommentViewController.swift
//  Instagram
//
//  Created by ALLAN CHAI on 15/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

  //  let image : UIImage
   // let usename, time : String
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var MessageLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var messageTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.delegate = self
        commentTableView.dataSource = self
        self.title = "Huan Huan"
        messageTimeLabel.text = "13mins ago"
        profilePicture.image = UIImage(named: "pichu")
        MessageLabel.text = "This Pichu so cute, I make it as profile picture, love it! love it! love it! love it! love it! love it! love it!"
        
     // let size = profilePicture.frame.width
        
        profilePicture.layer.cornerRadius = 72/2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.shadowOpacity = 0.7
        profilePicture.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        profilePicture.layer.shadowRadius = 5
        profilePicture.layer.shadowColor = UIColor.black.cgColor
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        

    }
    
    
}

extension CommentViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.usernameLabel.text = "Villy"
        cell.commentLabel.text = "My pokemon is cute than your"
        cell.timeLabel.text = "9mins ago"
        cell.profileImage.image = #imageLiteral(resourceName: "jigglypuff")
        
        return cell
    }
    
    
}

extension CommentViewController : UITableViewDelegate{

}

