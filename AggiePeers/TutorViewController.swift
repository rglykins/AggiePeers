//
//  TutorViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 4/26/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
import RealmSwift
class TutorViewController: UITableViewController {
    
    var tutorClasses: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func cameBack(_ segue: UIStoryboardSegue){
        if  segue.identifier == "didApply"
        {
         let controller = segue.source as! TutorApplicationViewController
         let pickedSubject = controller.subject!
            let pickedNumber = Int(controller.number!)
         let pickedClass = "\(pickedSubject) \(pickedNumber!)"
         let alert = UIAlertController(title: "Submission Sent", message: "Your submission for \(pickedClass) has been sent. We will let you know when you are verified", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Got it!", style: .default){
                alert in
                let realm = userRealm
                guard let selectedClass = realm.object(ofType: SubjectInfo.self, forPrimaryKey: pickedSubject)?.classes.filter("classNum = %@", pickedNumber!).first
                else{
                        
                    print("Denied access")
                    return
                }
                guard let userProfile = realm.object(ofType: UserProfile.self, forPrimaryKey: SyncUser.current!.identity)
                    else{
                        print("Denied access: User not logged in")
                        return
                }
                try! realm.write {
                     selectedClass.tutors.append(userProfile)
                }
            }
         alert.addAction(alertAction)
         navigationController?.popViewController(animated: true)
         present(alert, animated: true)
      }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "applyClass"{
            
        }
    }
 

}
