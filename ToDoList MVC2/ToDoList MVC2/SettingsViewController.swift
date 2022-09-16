//
//  SettingsViewController.swift
//  ToDoList MVC2
//
//  Created by Тимур Гарипов on 13.09.22.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
    }

    @IBAction func onClickSwitch(_ sender: UISwitch) {
        
        let appDelegate = UIApplication.shared.windows.first
        
        if sender.isOn {
            appDelegate?.overrideUserInterfaceStyle = .light
            return
        }
        appDelegate?.overrideUserInterfaceStyle = .dark
    }
    
}
