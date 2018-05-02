//
//  ProfileDetailsViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 4/20/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileDetailsViewController: UIViewController {

    @IBOutlet weak var descriptField: UITextView!
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func done(){
        
        if(!descriptField.text!.isEmpty && !nameField.text!.isEmpty){
            let syncConfig = SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL)
            let realm = try! Realm(configuration: Realm.Configuration(syncConfiguration: syncConfig, objectTypes:[UserProfile.self]))
            
            let newProfile = UserProfile()
            newProfile.name = nameField.text!
            newProfile.descript = descriptField.text!
            newProfile.userId = SyncUser.current!.identity!
            try! realm.write{
                realm.add(newProfile, update: true)
            }
            performSegue(withIdentifier: "go", sender: newProfile)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! UITabBarController
        let controller2 = controller.viewControllers![0] as! ProfileTableViewController
        controller2.selectedProfile = sender as? UserProfile
    }
    

}
