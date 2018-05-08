//
//  TutorViewCell.swift
//  AggiePeers
//
//  Created by Robert Lykins on 5/3/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit

class TutorViewCell: UITableViewCell {

    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var statusBar: UILabel!
    @IBOutlet weak var ratingBar: UIProgressView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    var timer = Timer()
    var limit: Float?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.ratingBar.progress = 0.0
        photo.layer.borderWidth = 1.0
        photo.layer.masksToBounds = false
        photo.layer.borderColor = UIColor.white.cgColor
        photo.layer.cornerRadius = photo.frame.size.height/2
        photo.clipsToBounds = true
         timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.progressStep), userInfo: nil, repeats: true)


    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tutorData(tutorProfile user: UserProfile)
    {
        nameLabel.text! = user.name
        statusBar.text! = user.status
        limit = user.rating
        if let imageData = user.photo
        {
            let image = UIImage(data: imageData)
            photo.image = image
        }
    }
    
    @objc func progressStep(){
        if(self.ratingBar.progress >= limit!)
        {
            timer.invalidate()
        }
        else
        {
            self.ratingBar.progress += 0.05
            let progress = ratingBar.progress
            if progress >= 90.0
            {
                gradeLabel.text! = "A+"
                ratingBar.progressTintColor = UIColor.green
            }
            else if progress >= 80.0
            {
                gradeLabel.text! = "B+"
                ratingBar.progressTintColor = UIColor.yellow
            }
            else if progress >= 70.0
            {
                gradeLabel.text = "C+"
                ratingBar.progressTintColor = UIColor.orange
            }
            else
            {
                gradeLabel.text = "F"
                ratingBar.progressTintColor = UIColor.red
            }
            self.reloadInputViews()
        }
    }
    
    
}
