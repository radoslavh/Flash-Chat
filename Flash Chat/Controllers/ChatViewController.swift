//
//  ChatViewController.swift
//  Flash Chat
//
//  Created by Radoslav Hlinka on 03/12/2017.
//  Copyright © 2017 Radoslav Hlinka. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendPressed(_ sender: AnyObject) {
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
    }
}
