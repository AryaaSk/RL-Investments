//
//  amountCell.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 10/05/2021.
//

import UIKit

class amountCell: UITableViewCell {

    @IBOutlet var amountStepper: UIStepper!
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        selectedAmount = Int(amountStepper.value)
        self.textLabel?.text = String(Int(amountStepper.value))
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
