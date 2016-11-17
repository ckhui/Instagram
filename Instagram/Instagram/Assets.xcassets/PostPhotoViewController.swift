//
//  PostPhotoViewController.swift
//  Instagram
//
//  Created by ALLAN CHAI on 16/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import FirebaseAuth

class PostPhotoViewController: UIViewController {

    
    @IBOutlet weak var choosePhotoButton: UIButton! { didSet{
        choosePhotoButton.addTarget(self, action: #selector(onChoosePhotoButtonPressed(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBOutlet weak var postPhotoButton: UIButton! { didSet{
        postPhotoButton.addTarget(self, action: #selector(onPostButtonPressed(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var postDescTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func onPostButtonPressed(button: UIButton) {
        let desc = postDescTextView.text
        guard let image = imagePreview.image
        else {
            warningPopUp(withTitle: "No Image", withMessage: "choose image before post")
            return
        }
        
        Instagram().instagramActionPostInsta(desc: desc!, image: image)
        warningPopUp(withTitle: "Post Success", withMessage: "Yeah")
    }
    
    func onChoosePhotoButtonPressed(button: UIButton) {
        performSegue(withIdentifier: "postInstaToImagePicker", sender: self)
    }


       // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postInstaToImagePicker" {
            let vc : imagepickerViewController = segue.destination as! imagepickerViewController
            if let pic = imagePreview.image
            {
                vc.currentImage = pic
            }
            vc.delegate = self
        }
    }
    

    @IBAction func logoutTapped(_ sender: AnyObject) {
        let popUP = UIAlertController(title: "log out", message: "yer or no", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "YES", style: .default) { (action) in
            do
            {
                try FIRAuth.auth()?.signOut()
            }
            catch let logoutError {
                print(logoutError)
            }
            self.notifySuccessLogout()
        }
        
        popUP.addAction(noButton)
        popUP.addAction(yesButton)
        present(popUP, animated: true, completion: nil)
    }
    
    func notifySuccessLogout ()
    {
        let UserLogoutNotification = Notification (name: Notification.Name(rawValue: "UserLogoutNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(UserLogoutNotification)
    }
}

extension PostPhotoViewController : imagepickerViewControllerDelegate{
    func imagepickerVCDidSelectPicture(selectedImage: UIImage) {
        imagePreview.image = selectedImage
    }
}
