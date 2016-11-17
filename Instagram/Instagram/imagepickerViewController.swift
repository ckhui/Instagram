//
//  imagepickerViewController.swift
//  NewTweet
//
//  Created by NEXTAcademy on 11/14/16.
//  Copyright © 2016 Calvin.kl. All rights reserved.
//

import UIKit


protocol imagepickerViewControllerDelegate : class {
    func imagepickerVCDidSelectPicture(selectedImage : UIImage)
}

class imagepickerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    weak var delegate:imagepickerViewControllerDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    var  chosenImage : UIImage?
    var currentImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ASDASDA"
        if let image = currentImage{
            imageView.image = image

        }
        else{
            imageView.image = #imageLiteral(resourceName: "pichu")
        }
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.blue.cgColor
        
        picker.delegate = self
    }
    
    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
        
    }
    
    @IBAction func shootPhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //let size = imageView.bounds.size
        //let image = cropToBounds(image: chosenImage!, width: size.width, height: size.height)
        
        imageView.contentMode = .scaleAspectFit
        //imageView.image = image
        imageView.image = chosenImage
        
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDoneSelectTapped(_ sender: AnyObject) {
        if let image = chosenImage{
            delegate?.imagepickerVCDidSelectPicture(selectedImage: image)
        }
        
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func onBackButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func cropToBounds(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        
        let contextImage = image
        //let contextImage: UIImage = UIImage(CGImage: image.CGImage)!
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = width
        var cgheight: CGFloat = height
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect : CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        //let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!

        //let imageRef: CGImage = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
}

