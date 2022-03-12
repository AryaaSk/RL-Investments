//
//  xPlatSettings.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 02/06/2021.
//

import UIKit

class xPlatSettings: UIViewController {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func doneButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(Notification(name: Notification.Name("reloadPlatforms")))
        }
    }
    
}

extension xPlatSettings: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "platformSelect", for: indexPath) as! xPlatformSelection
        
        if indexPath.section == 0
        {
            if xPlatData[0].uppercased() == "PC"
            {
                cell.segmentedControl.selectedSegmentIndex = 0
            }
            else if xPlatData[0].uppercased() == "PS4"
            {
                cell.segmentedControl.selectedSegmentIndex = 1
            }
            else if xPlatData[0].uppercased() == "SWITCH"
            {
                cell.segmentedControl.selectedSegmentIndex = 2
            }
            else if xPlatData[0].uppercased() == "XBOX"
            {
                cell.segmentedControl.selectedSegmentIndex = 3
            }
            cell.tag = 0
        }
        else
        {
            if xPlatData[1].uppercased() == "PC"
            {
                cell.segmentedControl.selectedSegmentIndex = 0
            }
            else if xPlatData[1].uppercased() == "PS4"
            {
                cell.segmentedControl.selectedSegmentIndex = 1
            }
            else if xPlatData[1].uppercased() == "SWITCH"
            {
                cell.segmentedControl.selectedSegmentIndex = 2
            }
            else if xPlatData[1].uppercased() == "XBOX"
            {
                cell.segmentedControl.selectedSegmentIndex = 3
            }
            cell.tag = 1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Platform 1"
        }
        else
        {
            return "Platform 2"
        }
    }
}
