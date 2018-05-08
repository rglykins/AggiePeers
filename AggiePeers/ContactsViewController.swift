//  ContactsViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 5/3/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
import RealmSwift
class ContactsViewController: UITableViewController {
   
    var contacts = [[ChatInfo]]()
    var initial = true
    var notification: NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
//       let callingObjects =  chatRealm.objects(ChatInfo.self)
//        notification = callingObjects.observe
//            {
//                [weak self] (changes: RealmCollectionChange)
//                in
//
//                guard let tableView = self?.tableView else {return}
//                self?.contacts.append(Array(callingObjects.filter("studentId = %@", currentUser)))
//                self?.contacts.append((Array(callingObjects.filter("tutorId = %@", currentUser))))
//                switch changes {
//                case .initial:
//                    self?.initial = false
//                    tableView.reloadData()
//                case .update(_, let deletions, let insertions, let modifications):
//                    tableView.beginUpdates()
//                    tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
//                    tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
//                    tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section:0)}), with: .automatic)
//                    tableView.endUpdates()
//                default:
//                    return
//                }
//        }
        
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_CHAT_URL), objectTypes: [ChatInfo.self, MessageInfo.self])
        Realm.asyncOpen(configuration: config){[weak self] realm,error in
            if let realm = realm
            {
                let chats = realm.objects(ChatInfo.self)
                self?.contacts.append(Array(chats.filter("studentId = %@", currentUser)))
                self?.contacts.append(Array(chats.filter("tutorId = %@", currentUser)))
                self?.initial = false
                self?.tableView.reloadData()
            }
            else if let error = error{
                print(error)
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if contacts.count == 0
        {
            return 1
        }

            return 2
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if contacts.count == 0{
            return nil
        }

        if section == 0
        {
            return "Tutors"
        }
        else
        {
            return "Students"
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if initial{
            return 1
        }

        return contacts[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if initial{
            return tableView.dequeueReusableCell(withIdentifier: "loadData")!
        }
        else
        {
            if(contacts[1].count == 0 && contacts[0].count == 0)
            {
              return tableView.dequeueReusableCell(withIdentifier: "noData")!
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "contactdata") as! ContactViewCell
                
                if(indexPath.section == 0)
                {
                    cell.contactData(UserName: contacts[indexPath.section][indexPath.row].tutorId)
                }
                else
                {
                    cell.contactData(UserName: contacts[indexPath.section][indexPath.row].studentId)
                }
                
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (contacts.count < 1 || (contacts[0].count < 1 && contacts[1].count < 1))
        {
            return
        }
    
        let chat = contacts[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "showLogs", sender: chat)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showLogs"
        {
            let controller = segue.destination as! ChatLogViewController
            controller.chatData = sender as? ChatInfo
        }
    }
}
