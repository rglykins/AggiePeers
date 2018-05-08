//
//  ChatLogViewController.swift
//  AggiePeers
//
//  Created by Robert Lykins on 5/3/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import UIKit
import RealmSwift
class ChatLogViewController: UIViewController {
   
    
    
    
    
    @IBOutlet weak var textField: UITextField!
    var chatData: ChatInfo?
    var notification: NotificationToken?
    var receiver: UIImage?
    var sender: UIImage?
    var messageInfo = [MessageInfo]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        
        if currentUser == chatData!.studentId{
            
          sender = UIImage(data: userRealm.object(ofType: UserProfile.self, forPrimaryKey: currentUser)!.photo!)
          receiver = UIImage(data: userRealm.object(ofType: UserProfile.self, forPrimaryKey: chatData!.tutorId)!.photo!)
        }else{
            sender = UIImage(data: userRealm.object(ofType: UserProfile.self, forPrimaryKey: currentUser)!.photo!)
            receiver = UIImage(data: userRealm.object(ofType: UserProfile.self, forPrimaryKey: chatData!.studentId)!.photo!)
        }
        
        
        
        let messages = chatData!.messages
        print(messages)
        notification = messages.observe
        {
        [weak self] (changes: RealmCollectionChange)
        in
            guard let tableView = self?.tableView else {return}
            guard let messageinfos = self?.chatData!.messages else {return}
            self?.messageInfo = Array(messageinfos)
            
            switch changes {
            case .initial:
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

    deinit {
        notification?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createMessage(){
        if textField.text!.isEmpty
        {
            
            
            
        }
        else{
        let message = MessageInfo()
        message.content = textField.text!
        message.sender = currentUser
        
        try! chatRealm.write{
            chatRealm.add(message)
            chatData!.messages.append(message)
        }
            textField.text! = ""
        }
        
    }
  
}



extension ChatLogViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      return  messageInfo.count
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
      let message = messageInfo[indexPath.row]
        if message.sender == currentUser
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sender") as! SenderViewCell
            cell.isUserInteractionEnabled = false
            cell.message(message, sender)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "receiver") as! ReceiverViewCell
            cell.isUserInteractionEnabled = false
            cell.message(message, receiver)
            return cell
        }
    }
}
