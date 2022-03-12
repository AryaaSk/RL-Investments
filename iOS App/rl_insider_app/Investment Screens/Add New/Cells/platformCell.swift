//
//  platformCell.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 10/05/2021.
//

import UIKit

class platformCell: UITableViewCell {

    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBAction func platformChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            selectedPlatform = "PC"
        case 1:
            selectedPlatform = "PS4"
        case 2:
            selectedPlatform = "Switch"
        case 3:
            selectedPlatform = "Xbox"
        default:
            break
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
