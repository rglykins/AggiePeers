//
//  RequestsTableViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 5/2/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
import RealmSwift
class RequestsTableViewController: UITableViewController {
    var requests = [RequestInfo]()
    var notification: NotificationToken?
    var onInit = true
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentUser)
        let requestsData = requestsRealm.objects(RequestInfo.self).filter("tutorId = %@ and status = 'PENDING'", currentUser)
        notification = requestsData.observe
            {
                [weak self] (changes: RealmCollectionChange)
                in
                
                guard let tableView = self?.tableView else {return}
                self?.requests = Array(requestsData)
                switch changes {
                case .initial:
                    self?.onInit = false
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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit
    {
        notification?.invalidate()
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestsdata")!
        let label = cell.viewWithTag(420) as! UILabel
        let studentId = requests[indexPath.row].studentId
        let userProf = userRealm.object(ofType: UserProfile.self, forPrimaryKey: studentId)
        label.text! = userProf!.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = requests[indexPath.row]
        performSegue(withIdentifier: "viewRequest", sender: request)
    }
    
    @IBAction func accept(_ segue: UIStoryboardSegue){
        let controller = segue.source as! StudentRequestViewController
        let chatData = controller.chet!
        
        try! chatRealm.write {
            chatRealm.add(chatData)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewRequest"{
            let controller = segue.destination as! StudentRequestViewController
            controller.request = sender as? RequestInfo
        }
        else if segue.identifier == "viewLogs" {
            let controller = segue.destination as! ChatLogViewController
            controller.chatData = sender as? ChatInfo
        }
    }
}
