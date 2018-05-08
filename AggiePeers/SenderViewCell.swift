//
//  MessageViewCell.swift
//  AggiePeers
//
//  Created by Robert Lykins on 5/4/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit

class SenderViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var photo: UIImageView!
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
    
    func message(_ message: MessageInfo, _ photo: UIImage?){
        label.text! = message.content
        self.photo.image = photo
    }

}
