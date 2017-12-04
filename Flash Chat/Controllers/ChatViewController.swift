//
//  ChatViewController.swift
//  Flash Chat
//
//  Created by Radoslav Hlinka on 03/12/2017.
//  Copyright © 2017 Radoslav Hlinka. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    var messageArr: [Message] = [Message]()
    
    private let MESSAGE_DB: String = "Messages"
    private let SENDER_KEY: String = "Sender"
    private let MESSAGE_BODY_KEY: String = "MessageBody"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        let msg = messageArr[indexPath.row]
        cell.messageBody.text = msg.messageBody
        cell.senderUsername.text = msg.sender
        cell.avatarImageView.image = UIImage(named: "egg")		
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        
        return cell
    }
    
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child(MESSAGE_DB)
        let messagesDictionary = [SENDER_KEY: Auth.auth().currentUser?.email,
                                  MESSAGE_BODY_KEY: messageTextfield.text]
        
        messagesDB.childByAutoId().setValue(messagesDictionary) {
            (error, reference) in
                if error != nil {
                    print(error!)
                } else {
                    print("Message saved successfully!")
                    self.messageTextfield.isEnabled = true
                    self.sendButton.isEnabled = true
                    self.messageTextfield.text = ""
                }
        }
    }
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child(MESSAGE_DB)
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let msg = Message()
            msg.sender = snapshotValue[self.SENDER_KEY]!
            msg.messageBody = snapshotValue[self.MESSAGE_BODY_KEY]!
            
            self.messageArr.append(msg)
            
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do{
            try Auth.auth().signOut()
        } catch {
            print("error during signing out")
        }
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No root controller")
                return
        }
    }
}
