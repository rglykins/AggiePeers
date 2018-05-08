//
//  HelperViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 4/26/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
import RealmSwift
struct PickerInfo{
    
    let tag: Int
    let name: String?
    var chosen: String?
    let givenData: [String]?
    
}
class HelperViewController: UIViewController, UIPickerViewControllerDelegate {
    var tutorData = [UserProfile]()
    var classData:[String:[String]] = [:]
    var subject: String?
    var number: String?
    var notification: NotificationToken?
    var initial = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subjectButton: UIButton!
    @IBOutlet weak var numButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classData = userData
        print("HELLLO")
        subjectButton!.setTitle("Choose", for: .normal)
        numButton!.setTitle("Choose", for: .normal)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickedPicker(_ sender: UIButton){
        switch sender.tag{
            case 100:
                performSegue(withIdentifier: "showPicker", sender: PickerInfo(tag: sender.tag, name: "subject", chosen: "E E", givenData: Array(classData.keys)))
            case 101:
                if subjectButton.titleLabel!.text! == "Choose"{
                    let alert = UIAlertController(title: "Choose subject", message: "Please choose a subject first", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Okay!", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    present(alert,animated: true)
                }
                else{
                    performSegue(withIdentifier: "showPicker", sender: PickerInfo(tag: sender.tag, name: "number", chosen: "100", givenData: classData[subjectButton.titleLabel!.text!]))
                }
            default:
              break
        }
    }
    
    @IBAction func pickerClicked(_ segue: UIStoryboardSegue){
        
        let controller = segue.source as! UIPickerViewController
        guard let pickerInfo = controller.pickerInfo else
        {
            fatalError("Error")
        }

        
        switch pickerInfo.tag
        {
            case 100:
                subjectButton.setTitle(pickerInfo.chosen, for: .normal)
                numButton.setTitle("All", for: .normal)
                updateData(subject: pickerInfo.chosen!, number: "All")
            case 101:
                 numButton.setTitle(pickerInfo.chosen, for: .normal)
                 updateData(subject: subjectButton.titleLabel!.text!, number: pickerInfo.chosen!)
                default:
             break
        }
    }
    
    
    
    
    
    func updateData(subject subCall: String, number numCall: String){
        print("\(subCall) \(numCall)")
        
        // Creates the loading page
        
        tutorData = []
        initial = true
        tableView.reloadData()
        
        let callingObject = userRealm.object(ofType: SubjectInfo.self, forPrimaryKey: subCall)!.classes
        
        
        notification = callingObject.observe({
            [weak self] (changes: RealmCollectionChange)
            in
            guard let tableView = self?.tableView else {return}
            
            
            if numCall == "All"{
                for c in callingObject
                {
                    self?.tutorData.append(contentsOf: Array(c.tutors.filter("userId != %@", currentUser)))
                }
            }
            else {
                self?.tutorData.append(contentsOf: Array(callingObject.filter("classId = %@", numCall).first!.tutors.filter("userId != %@", currentUser)))
            }
            
            
            
            
            switch changes {
            case .initial:
                self?.initial = false
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section:0)}), with: .automatic)
                tableView.endUpdates()
            default:
                return
            }
        })
        
        
        
        return
    }
    deinit{
        notification?.invalidate()
    }
    override func viewWillDisappear(_ animated: Bool) {
        notification?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
        notification?.invalidate()
        if segue.identifier == "showPicker"
        {
            let controller = segue.destination as! UIPickerViewController
            controller.pickerInfo = sender as? PickerInfo
            controller.delegate = self
        }
        if segue.identifier == "showTutor"{
            let controller = segue.destination as! ProfileTableViewController
            controller.selectedProfile = sender as? UserProfile
            controller.selectedClass = "E E 443"
            controller.userView = false
        }
    }
 
    
    
    func finishedPicker(_ controller: UIPickerViewController, pickerInfo info: PickerInfo) {
        switch info.tag
        {
        case 100:
            subjectButton.setTitle(info.chosen, for: .normal)
            numButton.setTitle("All", for: .normal)
            updateData(subject: info.chosen!, number: "All")
        case 101:
            numButton.setTitle(info.chosen, for: .normal)
            updateData(subject: subjectButton.titleLabel!.text!, number: info.chosen!)
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension HelperViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if initial {
            return 1
        }
        else
        {
            if tutorData.count < 1{
                return 1
            }
            else{
            return tutorData.count
            }
            }
        
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if initial{
            let cell: UITableViewCell
            if subjectButton.titleLabel!.text! == "Choose"
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "initView")!
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "Loading")!
            }
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        else
        {
           if tutorData.count == 0
           {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noData")!
                cell.isUserInteractionEnabled = false
                return cell
           }
          else
           {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tutorData") as! TutorViewCell
            cell.tutorData(tutorProfile: tutorData[indexPath.row])
            return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tutorData.count < 1 {
            return
        }
        
        let profile = tutorData[indexPath.row]
        performSegue(withIdentifier: "showTutor", sender: profile)
    }
    
    
}
