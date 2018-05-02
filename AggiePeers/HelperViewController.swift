//
//  HelperViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 4/26/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subjectButton: UIButton!
    @IBOutlet weak var numButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classData = userData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickedPicker(_ sender: UIButton){
        switch sender.tag{
            case 100:
                performSegue(withIdentifier: "showPicker", sender: PickerInfo(tag: sender.tag, name: "subject", chosen: "E E", givenData: Array(classData.keys)))
            case 101:
                performSegue(withIdentifier: "showPicker", sender: PickerInfo(tag: sender.tag, name: "number", chosen: "100", givenData: classData[subjectButton.titleLabel!.text!]))
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
        tutorData = []
        
        guard let callingObject = userRealm.object(ofType: SubjectInfo.self, forPrimaryKey: subCall)
            else{
                return
        }
        
        if numCall == "All"{

            let classes = Array(callingObject.classes)
            for c in classes{
                let profiles = Array(c.tutors)
                for profile in profiles
                {
                    tutorData.append(profile)
                }
            }
        }
        else {
            if let classInfo = callingObject.classes.filter("classNum = %@", Int(numCall)!).first{
                
                let profiles = Array(classInfo.tutors)
                
                for profile in profiles
                {
                    tutorData.append(profile)
                }
            }
        }
        tableView.reloadData()
        return
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPicker"
        {
            let controller = segue.destination as! UIPickerViewController
            controller.pickerInfo = sender as? PickerInfo
            controller.delegate = self
        }
        if segue.identifier == "showTutor"{
            
            let controller = segue.destination as! ProfileTableViewController
            controller.selectedProfile = sender as? UserProfile
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
       return tutorData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tutorData")!
        let label = cell.viewWithTag(420) as! UILabel
        label.text! = tutorData[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profile = tutorData[indexPath.row]
        performSegue(withIdentifier: "showTutor", sender: profile)
    }
}
