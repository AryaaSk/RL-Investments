//
//  addNewItemSelection.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 08/05/2021.
//

import UIKit

class addNewItemSelection: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        filteredData = items
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("reloadItems"), object: nil)
        
        tableView.reloadData()
    }
    
    @objc func reloadTableView()
    {
        tableView.reloadData()
    }
    
}

extension addNewItemSelection: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemSelectionCell", for: indexPath) as! itemSelectionCell
        if selectedItem == nil
        {
            cell.ImageView.image = nil
        }
        else
        {
            if selectedItem?.itemName == filteredData[indexPath.row].itemName
            {
                cell.ImageView.image = UIImage(systemName: "checkmark")
                cell.ImageView.tintColor = .link
            }
            else
            {
                cell.ImageView.image = nil
            }
        }
        cell.textLabel?.text = filteredData[indexPath.row].itemName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = filteredData[indexPath.row]
        selectedColour = "Default"
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension addNewItemSelection: UISearchBarDelegate
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
        tableView.reloadData()
    }
}

