//
//  ProfileTableViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 4/20/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileTableViewController: UITableViewController {
    
    
    var selectedProfile: UserProfile?
    var selectedClass: String?
    var userView: Bool = true
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descript: UITextView!
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var statusLabel: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        if let profile = selectedProfile
        {
            nameLabel.text! = profile.name
            descript.text! = profile.descript
            statusLabel.text! = profile.status
            
            if let data = profile.photo{
                imageView.image = UIImage(data: data)
            }
        }
        
        textView.layer.borderWidth = 2.0
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.cornerRadius = 5
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
        
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
        
        super.viewDidLoad()
        helpButton.isHidden = userView
        if userView{
        let cancer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        imageView.addGestureRecognizer(cancer)
        textField.isUserInteractionEnabled = true
        textView.isUserInteractionEnabled = true
        }
        else{
            print("HERE")
            textField.isUserInteractionEnabled = false
            textView.isUserInteractionEnabled = false
            textField.isEnabled = false
            textView.isEditable = false
        }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let profile = selectedProfile, let image = imageView.image{
            try! userRealm.write
            {
            profile.photo = UIImagePNGRepresentation(image)
            profile.descript = descript.text!
            profile.status = statusLabel.text!
            }
    }
    }
    @IBAction func getHelp(){
        
        if let _ = requestsRealm.objects(RequestInfo.self).filter("tutorId = %@ AND studentId = %@", selectedProfile!.userId, SyncUser.current!.identity!).first
        {
            let alert = UIAlertController(title: "Too many Requests", message: "You have already sent a request! Please wait until the tutor verifies.", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "Got it!", style: .default)
            alert.addAction(alertAct)
            present(alert,animated: true)
        }
        else{
            performSegue(withIdentifier: "requestHelp", sender: nil)
        }
        
    }
    @IBAction func requestForHelp(_ segue: UIStoryboardSegue){
        if segue.identifier == "requestSent"{
            
            let controller = segue.source as! StudentRequestViewController
            let request = controller.request!
            request.classId = selectedClass!
            request.tutorId = selectedProfile!.userId
            request.studentId = SyncUser.current!.identity!
            try! requestsRealm.write
            {
                requestsRealm.add(request)
            }
        }
        if segue.identifier == "showChats"{
        }
    }

    
    @objc func handleTap(_ tap: UIGestureRecognizer){
        let alert = UIAlertController(title: "Choosephoto", message: "fdsafdsa", preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel)
        let actPhoto = UIAlertAction(title: "Take Photo", style:.default){_ in self.photoCamera()}
        let actLib = UIAlertAction(title: "Choose from library", style: .default){_ in self.library()}
        alert.addAction(actCancel)
        alert.addAction(actPhoto)
        alert.addAction(actLib)
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source


}


extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func photoCamera(){
        print("HELLLO")
        if UIImagePickerController.isSourceTypeAvailable(.camera){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        }
    }
    func library(){
        print("HELLO")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
                self.imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


