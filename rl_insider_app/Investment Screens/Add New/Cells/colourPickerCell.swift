//
//  colourPickerCell.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 09/05/2021.
//

import UIKit

class colourPickerCell: UITableViewCell {

    @IBOutlet var colourPickerTextfield: UITextField!
    
    var pickerView = UIPickerView()
    
    let colours = ["Default", "Black", "Titanium White", "Grey", "Crimson", "Pink", "Cobalt", "Sky Blue", "Burnt Sienna", "Saffron", "Lime", "Forest Green", "Orange", "Purple"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        colourPickerTextfield.inputView = pickerView
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension colourPickerCell: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colours[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NotificationCenter.default.post(name: Notification.Name("reloadAddNewTableView"), object: nil)
        selectedColour = colours[row]
    }
}
