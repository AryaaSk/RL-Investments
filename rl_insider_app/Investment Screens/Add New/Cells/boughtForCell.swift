//
//  boughtForCell.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 10/05/2021.
//

import UIKit

class boughtForCell: UITableViewCell {

    @IBOutlet var textField: UITextField!
    
    @IBAction func textChanged(_ sender: Any) {
        let priceString = textField.text
        priceBoughtFor = (priceString! as NSString).integerValue
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
