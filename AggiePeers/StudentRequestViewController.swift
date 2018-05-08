//
//  StudentRequestViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 5/2/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit

class StudentRequestViewController: UITableViewController {

    @IBOutlet weak var descriptBox: UITextView!
    @IBOutlet weak var photo: UIImageView!
    var chet: ChatInfo?
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    
    
    var request: RequestInfo?
    var viewMode = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let request = request{
            submitButton.isHidden = true
            descriptBox.text! = request.descript
            descriptBox.isEditable = false
        }
        else{
            acceptButton.isHidden = true
            declineButton.isHidden = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()



    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "requestSent"
        {
            request = RequestInfo()
            request!.descript = descriptBox.text!
            request!.status = "PENDING"
            if let image = photo.image
            {
            request!.photo = UIImagePNGRepresentation(image)
            }
        }
        if segue.identifier == "acceptedRequest"
        {
            chet = ChatInfo()
            chet!.studentId = request!.studentId
            chet!.tutorId   = request!.tutorId
            chet!.classId   = request!.classId
        }
    }
 }

