//
//  LoginViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 4/20/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        let users = SyncUser.all
        for user in users
        {
            user.value.logOut()
        }
    }
    
    
    override func viewDidLoad() {
        errorMessageLabel.isHidden = true
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func done(){
        
        if (!usernameField.text!.isEmpty || !passwordField.text!.isEmpty)
        {
        let creds = SyncCredentials.usernamePassword(username: usernameField.text!, password: passwordField.text!)
        
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL)
        { user, error in
            if let user = user
            {
                let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: Constants.REALM_URL))
                Realm.asyncOpen(configuration: config){ realm, error in
                    
                    if let realm = realm{
                        if let userProfile = realm.object(ofType: UserProfile.self, forPrimaryKey: user.identity){
                            self.performSegue(withIdentifier: "userAuthenticated", sender: userProfile)
                        }
                        else{
                            self.performSegue(withIdentifier: "firstLogin", sender: nil)
                        }
                    }
                    else if let error = error{
                     print(error)
                    }
                    
                }
            }
            else if let error = error{
                print(error)
                self.showErrorLabel("The username or password is invalid. Please try again.")
            }
            else
            {
                self.showErrorLabel("Unable to establish connection. Please be sure you are connected to the internet.")
                fatalError("Something went wrong with Connection")
            }
        }
        }
        else
        {
            showErrorLabel("Please provide both a username and password.")
        }
    }

    func showErrorLabel(_ text: String){
        errorMessageLabel.isHidden = false
        errorMessageLabel.text! = text
    }


    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userAuthenticated"{
            let controller = segue.destination as! UITabBarController
            let controller2 = controller.viewControllers![0] as! UINavigationController
            let controller3 = controller2.viewControllers[0] as! ProfileTableViewController
            controller3.selectedProfile = sender as? UserProfile
        }
    }
 
    


}
