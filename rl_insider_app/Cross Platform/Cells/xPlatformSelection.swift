//
//  xPlatformSelection.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 02/06/2021.
//

import UIKit

class xPlatformSelection: UITableViewCell {

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            xPlatData[self.tag] = "PC"
            updateXPlatforms()
        case 1:
            xPlatData[self.tag] = "PS4"
            updateXPlatforms()
        case 2:
            xPlatData[self.tag] = "Switch"
            updateXPlatforms()
        case 3:
            xPlatData[self.tag] = "Xbox"
            updateXPlatforms()
        default:
            break
        }
    }
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
