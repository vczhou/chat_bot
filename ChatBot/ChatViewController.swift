//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Victoria Zhou on 3/15/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            // PFUser.currentUser() will now be nil
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userDidLogout"), object: nil)
        print("I've logged out")
    }

    @IBAction func onSendButton(_ sender: Any) {
        if let message = chatField.text {
            let pfMessage = PFObject(className: "Message")
            pfMessage["text"] = message
            pfMessage["user"] = PFUser.current()
                
            pfMessage.saveInBackground(block: { (success: Bool, error: Error?) in
                if (success) {
                    self.chatField.text = ""
                } else {
                    print(error?.localizedDescription ?? "Couldn't send message")
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = messages {
            return messages.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        cell.messageLabel.text = messages[indexPath.row]["text"] as! String!
        if let author = messages[indexPath.row]["user"] as? PFUser {
            cell.usernameLabel.text = author.username as String!
        } else {
            cell.usernameLabel.text = ""
        }
        
        return cell
    }
    
    func onTimer() {
        // Construct PFQuery
        let query = PFQuery(className: "Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        //query.limit = 20
        
        // Fetch data asynchronously
        query.findObjectsInBackground { (pfObjects: [PFObject]?, error: Error?) -> Void in
            if let pfObjects = pfObjects {
                self.messages = []
                
                // Only add if message is there
                for msg in pfObjects {
                    if (msg["text"] != nil) && ((msg["text"] as! String).characters.count > 0) {
                        self.messages.append(msg)
                    }
                }
                
                self.tableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription ?? "Failed to find messages")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
