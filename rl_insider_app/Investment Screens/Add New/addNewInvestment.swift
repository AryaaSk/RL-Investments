//
//  addNewInvestment.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 08/05/2021.
//

import UIKit

class addNewInvestment: UIViewController {

    @IBOutlet var addButtonOutlet: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("reloadAddNewTableView"), object: nil)
        
        
        if editingMode == false
        {
            addButtonOutlet.title = "Add"
        }
        else
        {
            addButtonOutlet.title = "Done"
        }
    }
    
    @objc func reloadTableView()
    {
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func cannotProceedAlert(message: String) -> UIAlertController
    {
        let alert = UIAlertController(title: "Cannot add this Investment", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return alert
    }
    
    @IBAction func addButton(_ sender: Any) {
        if editingMode == false
        {
            if selectedItem == nil
            {
                self.present(cannotProceedAlert(message: "You have not selected an Item"), animated: true, completion: nil)
            }
            else if selectedColour == nil
            {
                self.present(cannotProceedAlert(message: "You have not selected a Colour"), animated: true, completion: nil)
            }
            else
            {
                //also need to check whether that item can be painted or not but will get to that later
                
                if selectedItem?.getColourPrice(colour: selectedColour!, onPlatform: selectedPlatform) == nil
                {
                    self.present(cannotProceedAlert(message: "\(selectedItem!.itemName) does not come painted in \(selectedColour!) on \(selectedPlatform)"), animated: true, completion: nil)
                }
                else
                {
                    print(selectedPlatform)
                    print(priceBoughtFor)
                    print(selectedAmount)
                    investments.append(investmentItem(item: selectedItem!, colour: selectedColour!, quantity: selectedAmount, boughtFor: priceBoughtFor, platform: selectedPlatform))
                    saveInvestmentsData()
                    NotificationCenter.default.post(name: Notification.Name("reloadInvestments"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else
        {
            if selectedItem == nil
            {
                self.present(cannotProceedAlert(message: "You have not selected an Item"), animated: true, completion: nil)
            }
            else if selectedColour == nil
            {
                self.present(cannotProceedAlert(message: "You have not selected a Colour"), animated: true, completion: nil)
            }
            else if selectedAmount < 1
            {
                self.present(cannotProceedAlert(message: ""), animated: true, completion: nil)
            }
            else
            {
                if selectedItem?.getColourPrice(colour: selectedColour!, onPlatform: selectedPlatform) == nil
                {
                    self.present(cannotProceedAlert(message: "\(selectedItem!.itemName) does not come painted in \(selectedColour!) on \(selectedPlatform)"), animated: true, completion: nil)
                }
                else
                {
                    print(selectedPlatform)
                    print(priceBoughtFor)
                    print(selectedAmount)
                    investments[cellTag] = investmentItem(item: selectedItem!, colour: selectedColour!, quantity: selectedAmount, boughtFor: priceBoughtFor, platform: selectedPlatform)
                    saveInvestmentsData()
                    NotificationCenter.default.post(name: Notification.Name("reloadInvestments"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension addNewInvestment: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
            if selectedItem != nil
            {
                cell.textLabel?.textColor = .label
                cell.textLabel?.text = selectedItem?.itemName
            }
            else
            {
                cell.textLabel?.textColor = .gray
                cell.textLabel?.text = "No Item Selected"
            }
            return cell
        }
        else if indexPath.section == 0 && indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "colourPickerCell", for: indexPath) as! colourPickerCell
            if selectedColour != nil
            {
                cell.textLabel?.textColor = .label
                cell.textLabel?.text = selectedColour
            }
            else
            {
                cell.textLabel?.textColor = .gray
                cell.textLabel?.text = "No Colour Selected"
            }
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "platformCell", for: indexPath) as! platformCell
            if selectedPlatform.uppercased() == "PC"
            {
                cell.segmentedControl.selectedSegmentIndex = 0
            }
            else if selectedPlatform.uppercased() == "PS4"
            {
                cell.segmentedControl.selectedSegmentIndex = 1
            }
            else if selectedPlatform.uppercased() == "SWITCH"
            {
                cell.segmentedControl.selectedSegmentIndex = 2
            }
            else if selectedPlatform.uppercased() == "XBOX"
            {
                cell.segmentedControl.selectedSegmentIndex = 3
            }
            
            return cell
        }
        else if indexPath.section == 2 && indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "boughtForCell", for: indexPath) as! boughtForCell
            cell.textField.text = String(priceBoughtFor)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "amountCell", for: indexPath) as! amountCell
            cell.amountStepper.value = Double(selectedAmount)
            cell.textLabel?.text = String(Int(cell.amountStepper.value))
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Item"
        }
        else if section == 1
        {
            return "Platform"
        }
        else
        {
            return "Price Bought For and Quantity Bought"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            self.performSegue(withIdentifier: "selectItem", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
