//
//  ViewController.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 27/04/2021.
//

import UIKit
import Firebase
import Foundation

class ViewController: UIViewController {
    
    let userID = "USIAOIFHDSOIUP"
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBAction func platformChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            platform = "PC"
            updatePlatform()
            tableView.reloadData()
        case 1:
            platform = "PS4"
            updatePlatform()
            tableView.reloadData()
        case 2:
            platform = "SWITCH"
            updatePlatform()
            tableView.reloadData()
        case 3:
            platform = "XBOX"
            updatePlatform()
            tableView.reloadData()
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        filteredData = items
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("reloadItems"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if platform == "PC"
        {
            segmentedControl.selectedSegmentIndex = 0
        }
        else if platform == "PS4"
        {
            segmentedControl.selectedSegmentIndex = 1
        }
        else if platform == "SWITCH"
        {
            segmentedControl.selectedSegmentIndex = 2
        }
        else
        {
            segmentedControl.selectedSegmentIndex = 3
        }
    }
    
    @objc func reloadTableView()
    {
        self.tableView.reloadData()
    }

    func createPrice(price: [Int]?) -> String
    {
        if price != nil
        {
            let lowerBound = price![0]
            let upperBound = price![1]
            
            let priceRange = "\(lowerBound) - \(upperBound)"
            return priceRange
        }
        else
        {
            let priceRange = "No Price"
            return priceRange
        }
    }
    
    func createMessageForAlert(item: decodingitem) -> String
    {
        //just use pc prices for now
        var returnString = ""
        
        if platform == "PC"
        {
            returnString = returnString + "Default : \(createPrice(price: item.itemPriceRange.pc_price))\n"
            returnString = returnString + "Black : \(createPrice(price: item.itemPriceRange.black_pc_price))\n"
            returnString = returnString + "Titanium White : \(createPrice(price: item.itemPriceRange.white_pc_price))\n"
            returnString = returnString + "Grey : \(createPrice(price: item.itemPriceRange.grey_pc_price))\n"
            returnString = returnString + "Crimson : \(createPrice(price: item.itemPriceRange.crimson_pc_price))\n"
            returnString = returnString + "Pink : \(createPrice(price: item.itemPriceRange.pink_pc_price))\n"
            returnString = returnString + "Cobalt : \(createPrice(price: item.itemPriceRange.cobalt_pc_price))\n"
            returnString = returnString + "Sky Blue : \(createPrice(price: item.itemPriceRange.skyBlue_pc_price))\n"
            returnString = returnString + "Burnt Sienna : \(createPrice(price: item.itemPriceRange.burntSienna_pc_price))\n"
            returnString = returnString + "Saffron : \(createPrice(price: item.itemPriceRange.saffron_pc_price))\n"
            returnString = returnString + "Lime : \(createPrice(price: item.itemPriceRange.lime_pc_price))\n"
            returnString = returnString + "Forest Green : \(createPrice(price: item.itemPriceRange.forestGreen_pc_price))\n"
            returnString = returnString + "Orange : \(createPrice(price: item.itemPriceRange.orange_pc_price))\n"
            returnString = returnString + "Purple : \(createPrice(price: item.itemPriceRange.purple_pc_price))"
        }
        else if platform == "PS4"
        {
            returnString = returnString + "Default : \(createPrice(price: item.itemPriceRange.ps4_price))\n"
            returnString = returnString + "Black : \(createPrice(price: item.itemPriceRange.black_ps4_price))\n"
            returnString = returnString + "Titanium White : \(createPrice(price: item.itemPriceRange.white_ps4_price))\n"
            returnString = returnString + "Grey : \(createPrice(price: item.itemPriceRange.grey_ps4_price))\n"
            returnString = returnString + "Crimson : \(createPrice(price: item.itemPriceRange.crimson_ps4_price))\n"
            returnString = returnString + "Pink : \(createPrice(price: item.itemPriceRange.pink_ps4_price))\n"
            returnString = returnString + "Cobalt : \(createPrice(price: item.itemPriceRange.cobalt_ps4_price))\n"
            returnString = returnString + "Sky Blue : \(createPrice(price: item.itemPriceRange.skyBlue_ps4_price))\n"
            returnString = returnString + "Burnt Sienna : \(createPrice(price: item.itemPriceRange.burntSienna_ps4_price))\n"
            returnString = returnString + "Saffron : \(createPrice(price: item.itemPriceRange.saffron_ps4_price))\n"
            returnString = returnString + "Lime : \(createPrice(price: item.itemPriceRange.lime_ps4_price))\n"
            returnString = returnString + "Forest Green : \(createPrice(price: item.itemPriceRange.forestGreen_ps4_price))\n"
            returnString = returnString + "Orange : \(createPrice(price: item.itemPriceRange.orange_ps4_price))\n"
            returnString = returnString + "Purple : \(createPrice(price: item.itemPriceRange.purple_ps4_price))"
        }
        else if platform == "SWITCH"
        {
            returnString = returnString + "Default : \(createPrice(price: item.itemPriceRange.switch_price))\n"
            returnString = returnString + "Black : \(createPrice(price: item.itemPriceRange.black_switch_price))\n"
            returnString = returnString + "Titanium White : \(createPrice(price: item.itemPriceRange.white_switch_price))\n"
            returnString = returnString + "Grey : \(createPrice(price: item.itemPriceRange.grey_switch_price))\n"
            returnString = returnString + "Crimson : \(createPrice(price: item.itemPriceRange.crimson_switch_price))\n"
            returnString = returnString + "Pink : \(createPrice(price: item.itemPriceRange.pink_switch_price))\n"
            returnString = returnString + "Cobalt : \(createPrice(price: item.itemPriceRange.cobalt_switch_price))\n"
            returnString = returnString + "Sky Blue : \(createPrice(price: item.itemPriceRange.skyBlue_switch_price))\n"
            returnString = returnString + "Burnt Sienna : \(createPrice(price: item.itemPriceRange.burntSienna_switch_price))\n"
            returnString = returnString + "Saffron : \(createPrice(price: item.itemPriceRange.saffron_switch_price))\n"
            returnString = returnString + "Lime : \(createPrice(price: item.itemPriceRange.lime_switch_price))\n"
            returnString = returnString + "Forest Green : \(createPrice(price: item.itemPriceRange.forestGreen_switch_price))\n"
            returnString = returnString + "Orange : \(createPrice(price: item.itemPriceRange.orange_switch_price))\n"
            returnString = returnString + "Purple : \(createPrice(price: item.itemPriceRange.purple_switch_price))"
        }
        else
        {
            returnString = returnString + "Default : \(createPrice(price: item.itemPriceRange.xbox_price))\n"
            returnString = returnString + "Black : \(createPrice(price: item.itemPriceRange.black_xbox_price))\n"
            returnString = returnString + "Titanium White : \(createPrice(price: item.itemPriceRange.white_xbox_price))\n"
            returnString = returnString + "Grey : \(createPrice(price: item.itemPriceRange.grey_xbox_price))\n"
            returnString = returnString + "Crimson : \(createPrice(price: item.itemPriceRange.crimson_xbox_price))\n"
            returnString = returnString + "Pink : \(createPrice(price: item.itemPriceRange.pink_xbox_price))\n"
            returnString = returnString + "Cobalt : \(createPrice(price: item.itemPriceRange.cobalt_xbox_price))\n"
            returnString = returnString + "Sky Blue : \(createPrice(price: item.itemPriceRange.skyBlue_xbox_price))\n"
            returnString = returnString + "Burnt Sienna : \(createPrice(price: item.itemPriceRange.burntSienna_xbox_price))\n"
            returnString = returnString + "Saffron : \(createPrice(price: item.itemPriceRange.saffron_xbox_price))\n"
            returnString = returnString + "Lime : \(createPrice(price: item.itemPriceRange.lime_xbox_price))\n"
            returnString = returnString + "Forest Green : \(createPrice(price: item.itemPriceRange.forestGreen_xbox_price))\n"
            returnString = returnString + "Orange : \(createPrice(price: item.itemPriceRange.orange_xbox_price))\n"
            returnString = returnString + "Purple : \(createPrice(price: item.itemPriceRange.purple_xbox_price))"
        }
        
        return returnString
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if platform == "PC"
        {
            cell?.textLabel?.text = "\(filteredData[indexPath.row].itemName) : \(createPrice(price: filteredData[indexPath.row].itemPriceRange.pc_price))"
        }
        else if platform == "PS4"
        {
            cell?.textLabel?.text = "\(filteredData[indexPath.row].itemName) : \(createPrice(price: filteredData[indexPath.row].itemPriceRange.ps4_price))"
        }
        else if platform == "SWITCH"
        {
            cell?.textLabel?.text = "\(filteredData[indexPath.row].itemName) : \(createPrice(price: filteredData[indexPath.row].itemPriceRange.switch_price))"
        }
        else
        {
            cell?.textLabel?.text = "\(filteredData[indexPath.row].itemName) : \(createPrice(price: filteredData[indexPath.row].itemPriceRange.xbox_price))"
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredData[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: item.itemName, message: createMessageForAlert(item: item), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension ViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        for item in items
        {
            if item.itemName.uppercased().contains(searchText.uppercased())
            {
                filteredData.append(item)
            }
        }
        if searchText == ""
        {
            filteredData = items
        }
        
        self.tableView.reloadData()
    }
}
