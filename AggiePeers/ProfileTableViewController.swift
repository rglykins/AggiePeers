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
    var userView: Bool = true
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descript: UILabel!
    
    
    @IBOutlet weak var helpButton: UIButton!
    

    override func viewDidLoad() {
        if let profile = selectedProfile{
            nameLabel.text! = profile.name
            descript.text! = profile.descript
        }
        super.viewDidLoad()
        helpButton.isHidden = userView
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getHelp()
    {
        print("HELP ME FIGURE OUT WHAT TO DO WITH THIS PAGE")
    }
    
    
    
    // MARK: - Table view data source


}
