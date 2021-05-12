//
//  investmentOverview.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 08/05/2021.
//

import UIKit

class investmentOverview: UIViewController {

    @IBOutlet var totalBackground: UIView!
    @IBOutlet var totalSpentLabel: UILabel!
    @IBOutlet var totalIfSoldLabel: UILabel!
    @IBOutlet var totalProfitLabel: UILabel!
    
    @IBOutlet var totalBarButton: UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("reloadInvestments"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("reloadItems"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableViewDelay), name: NSNotification.Name("reloadItemsDelay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteItems), name: NSNotification.Name("deleteInvestment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editInvestment), name: NSNotification.Name("editInvestment"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        self.title = "Investments"
        
        totalSpentLabel.text = ""
        totalIfSoldLabel.text = ""
        totalProfitLabel.text = ""
        
        totalBackground.isHidden = true
        totalBarButton.isEnabled = false
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        totalBackground.addBorder(.top, color: .lightGray, thickness: 0.4)
    }
    
    @IBAction func addNewButton(_ sender: Any) {
        editingMode = false
        selectedItem = nil
        selectedColour = "Default"
        selectedPlatform = platform
        selectedAmount = 1
        priceBoughtFor = 100
        self.performSegue(withIdentifier: "addNew", sender: self)
    }
    
    @objc func reloadTableView()
    {
        tableView.reloadData()
        totalBarButton.isEnabled = true
    }
    
    @objc func reloadTableViewDelay()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.reloadData()
        }
    }
    
    @objc func deleteItems()
    {
        let alert = UIAlertController(title: "Are you sure you want to delete this investment", message: "You will have to create it again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { delete in
            self.tableView.beginUpdates()
            
            self.tableView.deleteRows(at: [IndexPath(row: cellTag, section: 0)], with: .automatic)
            investments.remove(at: cellTag)
            saveInvestmentsData()
            
            NotificationCenter.default.post(name: NSNotification.Name("reloadItemsDelay"), object: nil)
            
            self.tableView.endUpdates()
        }))
        self.present(alert, animated: true, completion: nil)
        
        print(investments)
    }
    
    @objc func editInvestment()
    {
        editingMode = true
        selectedItem = investments[cellTag].item
        selectedColour = investments[cellTag].colour
        selectedPlatform = investments[cellTag].platform
        selectedAmount = investments[cellTag].quantity
        priceBoughtFor = investments[cellTag].boughtFor
        self.performSegue(withIdentifier: "addNew", sender: self)
    }

    @IBAction func showTotal(_ sender: Any) {
        //get total spent, go through investments and add up
        var totalSpent = 0
        var totalIfSoldLowerBound = 0
        var totalIfSoldUpperBound = 0
        var i = 0
        while i != investments.count
        {
            totalSpent += (investments[i].boughtFor * investments[i].quantity)
            totalIfSoldLowerBound += investments[i].item.getColourPrice(colour: investments[i].colour, onPlatform: investments[i].platform)![0] * investments[i].quantity
            totalIfSoldUpperBound += investments[i].item.getColourPrice(colour: investments[i].colour, onPlatform: investments[i].platform)![1] * investments[i].quantity
            i += 1
        }
        
        let totalProfitLowerBound = totalIfSoldLowerBound - totalSpent
        let totalProfitUpperBound = totalIfSoldUpperBound - totalSpent
        
        var profitLowerBoundString = String(totalProfitLowerBound)
        var profitUpperBoundString = String(totalProfitUpperBound)
        
        if totalProfitLowerBound < 0
        {
            profitLowerBoundString = "(\(String(totalProfitLowerBound)))"
        }
        if totalProfitUpperBound < 0
        {
            profitUpperBoundString = "(\(String(totalProfitUpperBound)))"
        }
        
        var message = ""
        message.append("Total Spent : \(String(totalSpent))\n")
        message.append("Total if Sold Now: \(totalIfSoldLowerBound) - \(totalIfSoldUpperBound)\n")
        message.append("Total Profit: \(profitLowerBoundString) - \(profitUpperBoundString)")
        
        let alert = UIAlertController(title: "Total", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension investmentOverview: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return investments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! itemCell
        cell.itemNameLabel.text = "\(investments[indexPath.row].colour) \(investments[indexPath.row].item.itemName)"
        
        if investments[indexPath.row].platform.uppercased() == "PC"
        {
            cell.platformIcon.image = UIImage(named: "PC Icon")
        }
        else if investments[indexPath.row].platform.uppercased() == "PS4"
        {
            cell.platformIcon.image = UIImage(named: "PS4 Icon")
        }
        else if investments[indexPath.row].platform.uppercased() == "SWITCH"
        {
            cell.platformIcon.image = UIImage(named: "Switch Icon")
        }
        else if investments[indexPath.row].platform.uppercased() == "XBOX"
        {
            cell.platformIcon.image = UIImage(named: "Xbox Icon")
        }
        else
        {
            cell.platformIcon.image = nil
        }
        
        if investments[indexPath.row].quantity > 1
        {
            cell.totalBoughtSpentLabel.text = "Bought \(investments[indexPath.row].quantity) for \(investments[indexPath.row].boughtFor) each, Total: \(investments[indexPath.row].quantity * investments[indexPath.row].boughtFor)"
        }
        else
        {
            cell.totalBoughtSpentLabel.text = "Bought \(investments[indexPath.row].quantity) for \(investments[indexPath.row].boughtFor)"
        }
        
        let priceRange = investments[indexPath.row].item.getColourPrice(colour: investments[indexPath.row].colour, onPlatform: investments[indexPath.row].platform)
        //there shouldnt be any nil values as it gets filtered out during the adding process
        cell.currentPriceLabel.text = "Current Price: \(priceRange![0]) - \(priceRange![1])"
        
        cell.totalNowLabel.text = "Total if Sold Now: \(priceRange![0] * investments[indexPath.row].quantity) - \(priceRange![1] * investments[indexPath.row].quantity)"
        
        let totalSpent = investments[indexPath.row].quantity * investments[indexPath.row].boughtFor
        let profitLowerBound = priceRange![0] * investments[indexPath.row].quantity - totalSpent
        let profitUpperBound = priceRange![1] * investments[indexPath.row].quantity - totalSpent
        
        var profitLowerBoundString = String(profitLowerBound)
        var profitUpperBoundString = String(profitUpperBound)
        
        if profitLowerBound < 0
        {
            profitLowerBoundString = "(\(String(profitLowerBound)))"
        }
        if profitUpperBound < 0
        {
            profitUpperBoundString = "(\(String(profitUpperBound)))"
        }
        
        cell.profitLabel.text = "Profit: \(profitLowerBoundString) - \(profitUpperBoundString)"
        
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
