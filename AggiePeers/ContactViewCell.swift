//
//  ContactViewCell.swift
//  AggiePeers
//
//  Created by Robert Lykins on 5/3/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {
   
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var user: UserProfile?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photo.layer.borderWidth = 1.0
        photo.layer.masksToBounds = false
        photo.layer.borderColor = UIColor.white.cgColor
        photo.layer.cornerRadius = photo.frame.size.height/2
        photo.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func contactData(UserName username: String)
    {
        
        let user = userRealm.object(ofType: UserProfile.self, forPrimaryKey: username)!
        
        if let data = user.photo
        {
            photo.image = UIImage(data: data)
        }
        nameLabel.text! = user.name
        statusLabel.text! = user.status
    }
}
