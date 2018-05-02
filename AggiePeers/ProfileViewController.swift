//
//  ProfileViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 4/20/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
class ProfileViewController: UITableViewController {
    
    var selectedProfile: UserProfile?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descript: UITextView!
    var userView: Bool = true
//    required init?(coder aDecoder: NSCoder) {
//        let syncConfig = SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL)
//        realm = try! Realm(configuration: Realm.Configuration(syncConfiguration: syncConfig, objectTypes:[UserProfile.self]))
//        selectedProfile = nil
//        super.init(coder: aDecoder)
//    }
    override func viewDidLoad() {
        if let profile = selectedProfile{
            nameLabel.text! = profile.name
            descript.text! = profile.descript
        }
        super.viewDidLoad()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
