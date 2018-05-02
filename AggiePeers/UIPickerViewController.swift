//
//  UIPickerViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 4/26/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit


protocol UIPickerViewControllerDelegate: class
{
    func finishedPicker(_ controller: UIPickerViewController, pickerInfo info: PickerInfo)
}

class UIPickerViewController: UIViewController {
    var label: String?
    var choices: [String]?
    var pickerInfo: PickerInfo?
    weak var delegate: UIPickerViewControllerDelegate?
    
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        chooseLabel.text = "Choose a " + (pickerInfo?.name ?? "blah")
        choices = pickerInfo?.givenData
        picker.dataSource = self
        picker.delegate = self
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    
    
    @IBAction func close()
    {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func done()
    {
        pickerInfo!.chosen = pickerInfo!.givenData![picker.selectedRow(inComponent: 0)]
        delegate?.finishedPicker(self, pickerInfo: pickerInfo!)
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "PickedPicker"{
//            print(picker.selectedRow(inComponent: 0).description)
//            pickerInfo!.chosen = pickerInfo!.givenData![picker.selectedRow(inComponent: 0)]
//        }
//    }

}

extension UIPickerViewController: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PickerPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    
    
}


extension UIPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices?[row]
    }
}
