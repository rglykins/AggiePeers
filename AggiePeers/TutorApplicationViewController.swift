//
//  TutorApplicationViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 4/27/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
class TutorApplicationViewController: UITableViewController, UIPickerViewControllerDelegate {

    
    @IBOutlet weak var subjectName: UIButton!
    @IBOutlet weak var numberName: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var pickerData: PickerInfo?
    var subject: String?
    var number: String?
    var classData: [String:[String]] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        
        self.classData = userData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // This function sends the data that's available to the view controller that helps a user pick a class
    
    @IBAction func handlePicker(_ sender: UIButton){
    switch sender.tag{
    case 102:
        performSegue(withIdentifier: "showPickerForm", sender: PickerInfo(tag: sender.tag, name: "subject", chosen: "E E", givenData: Array(classData.keys)))
    case 103:
        if subjectName.titleLabel!.text! == "Choose"
        {
            let alert = UIAlertController(title: "~Choose a subject!~", message: "In order to choose a number you must choose a subject first!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Got It!", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
        else
        {
            performSegue(withIdentifier: "showPickerForm", sender:  PickerInfo(tag: sender.tag, name: "number", chosen: "100", givenData: classData[subjectName.titleLabel!.text!]))
        }
    default:
      break
    }
    }
    
    
    // This function sets the labels to their corresponding classes
    
    func finishedPicker(_ controller: UIPickerViewController, pickerInfo info: PickerInfo) {
        
        switch info.tag
        {
        case 102:
            subjectName.setTitle(info.chosen, for: .normal)
            numberName.setTitle("Choose", for: .normal)
        case 103:
            numberName.setTitle(info.chosen, for: .normal)
            submitButton.isEnabled = true
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }


    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "didApply"{
            subject = "\(subjectName.titleLabel!.text!)"
            number =  "\(numberName.titleLabel!.text!)"
        }
        if segue.identifier == "showPickerForm"
        {
            let controller = segue.destination as! UIPickerViewController
            controller.delegate = self
            controller.pickerInfo = sender as? PickerInfo
        }
    }
}


