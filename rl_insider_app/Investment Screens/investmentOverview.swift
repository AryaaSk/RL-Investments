//
//  investmentOverview.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 08/05/2021.
//

import UIKit
import Charts

class investmentOverview: UIViewController {

    @IBOutlet var totalBackground: UIView!
    @IBOutlet var totalSpentLabel: UILabel!
    @IBOutlet var totalIfSoldLabel: UILabel!
    @IBOutlet var totalProfitLabel: UILabel!
    
    @IBOutlet var totalBarButton: UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var mainActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("reloadInvestments"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("reloadItems"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableViewDelay), name: NSNotification.Name("reloadItemsDelay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteItems), name: NSNotification.Name("deleteInvestment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editInvestment), name: NSNotification.Name("editInvestment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(groupInvesment), name: NSNotification.Name("groupInvestment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(amountChangedInvestment), name: NSNotification.Name("amountChangedInvestment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showRLInsiderChart), name: NSNotification.Name("showRLInsiderChart"), object: nil)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        self.title = "Investments"
        
        totalSpentLabel.text = ""
        totalIfSoldLabel.text = ""
        totalProfitLabel.text = ""
        
        totalBackground.isHidden = true
        totalBarButton.isEnabled = false
        
        tableView.isHidden = true
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        mainActivityIndicator.isHidden = false
        mainActivityIndicator.startAnimating()
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        totalBackground.addBorder(.top, color: .lightGray, thickness: 0.4)
    }
    
    func updateFilteredInvestments()
    {
        for investment in investments
        {
            if investment.item.itemName.uppercased().contains(self.searchBar.text!.uppercased())
            {
                investmentFilteredData.append(investment)
            }
        }
        if self.searchBar.text == ""
        {
            investmentFilteredData = investments
        }
    }
    
    @IBAction func addNewButton(_ sender: Any) {
        editingMode = false
        selectedItem = nil
        selectedColour = "Default"
        selectedPlatform = platform
        selectedAmount = 1
        priceBoughtFor = 100
        selectedID = investmentID()
        self.performSegue(withIdentifier: "addNew", sender: self)
    }
    
    @objc func reloadTableView()
    {
        mainActivityIndicator.isHidden = true
        mainActivityIndicator.stopAnimating()
        investmentFilteredData = investments
        tableView.reloadData()
        totalBarButton.isEnabled = true
        tableView.isHidden = false
    }
    
    @objc func reloadTableViewDelay()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
    }
    
    @objc func deleteItems()
    {
        let alert = UIAlertController(title: "Are you sure you want to delete this investment", message: "You will have to create it again", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { delete in
            
            //cell tag is the position of the item in investments, but we need the position in investmentsfiltereddata
            
            if cellTag == investments.count
            {
                cellTag -= 1
            }
            
            var filteredCellTag = 0
            var i = 0
            while i != investmentFilteredData.count
            {
                if investmentFilteredData[i].id == investments[cellTag].id
                {
                    filteredCellTag = i
                }
                i += 1
            }
            
            investmentFilteredData.remove(at: filteredCellTag)
            
            if self.searchBar.text == "" || self.searchBar.text == " "
            {
                investments.remove(at: cellTag)
                saveInvestmentsData()
                self.tableView.deleteRows(at: [IndexPath(row: filteredCellTag, section: 0)], with: .automatic)
            }
            else if investmentFilteredData.count == 1
            {
                investments.remove(at: cellTag)
                saveInvestmentsData()
                self.tableView.deleteRows(at: [IndexPath(row: filteredCellTag, section: 0)], with: .automatic)
            }
            else
            {
                investments.remove(at: cellTag)
                saveInvestmentsData()
                self.searchBar.text = ""
                self.tableView.reloadData()
            }
            
            
            NotificationCenter.default.post(name: NSNotification.Name("reloadItemsDelay"), object: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editInvestment()
    {
        editingMode = true
        selectedItem = investments[cellTag].item
        selectedColour = investments[cellTag].colour
        selectedPlatform = investments[cellTag].platform
        selectedAmount = investments[cellTag].quantity
        priceBoughtFor = investments[cellTag].boughtFor
        selectedID = investments[cellTag].id
        self.performSegue(withIdentifier: "addNew", sender: self)
    }
    
    @objc func showRLInsiderChart()
    {
        self.performSegue(withIdentifier: "rlInsiderChart", sender: self)
    }
    
    @objc func amountChangedInvestment()
    {
        investments[cellTag].quantity = currentAmount
        saveInvestmentsData()
        
        investmentFilteredData = []
        for investment in investments
        {
            if investment.item.itemName.uppercased().contains(searchBar.text!.uppercased())
            {
                investmentFilteredData.append(investment)
            }
        }
        if searchBar.text! == ""
        {
            investmentFilteredData = investments
        }
        
        tableView.reloadData()
    }
    
    @objc func groupInvesment()
    {
        print(investments[cellTag].item.itemName)
        //first check if there is already a group
        var groupAlreadyExists = false
        var i = 0
        while i != groups.count
        {
            if groups[i].itemName == investments[cellTag].item.itemName && groups[i].platform.uppercased() == investments[cellTag].platform.uppercased()
            {
                groupAlreadyExists = true
                //there is already a group, just reset it and go through the invesments to add to it
                groups[i].itemIDS = []
                var a = 0
                while a != investments.count
                {
                    if investments[a].item.itemName == groups[i].itemName && investments[a].platform.uppercased() == groups[i].platform.uppercased()
                    {
                        groups[i].itemIDS.append(investments[a].id)
                    }
                    a += 1
                }
            }
            i += 1
        }
        
        if groupAlreadyExists == false
        {
            var newGroup = investmentGroup(itemName: investments[cellTag].item.itemName, platform: investments[cellTag].platform, itemIDS: [])
            var a = 0
            while a != investments.count
            {
                if investments[a].item.itemName == newGroup.itemName && investments[a].platform.uppercased() == newGroup.platform.uppercased()
                {
                    newGroup.itemIDS.append(investments[a].id)
                }
                a += 1
            }
            
            groups.append(newGroup)
        }
        saveGroupData()
        
        print(groups)
        
    }

    @IBAction func showTotal(_ sender: Any) {
        //get total spent, go through investments and add up
        var totalSpent = 0
        var totalIfSoldLowerBound = 0
        var totalIfSoldUpperBound = 0
        var i = 0
        while i != investmentFilteredData.count
        {
            totalSpent += (investmentFilteredData[i].boughtFor * investmentFilteredData[i].quantity)
            totalIfSoldLowerBound += investmentFilteredData[i].item.getColourPrice(colour: investmentFilteredData[i].colour, onPlatform: investmentFilteredData[i].platform)![0] * investmentFilteredData[i].quantity
            totalIfSoldUpperBound += investmentFilteredData[i].item.getColourPrice(colour: investmentFilteredData[i].colour, onPlatform: investmentFilteredData[i].platform)![1] * investmentFilteredData[i].quantity
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
        message.append("Total Profit/Loss: \(profitLowerBoundString) - \(profitUpperBoundString)")
        
        let alert = UIAlertController(title: "Total", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension investmentOverview: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return investmentFilteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! itemCell
        cell.itemNameLabel.text = "\(investmentFilteredData[indexPath.row].colour) \(investmentFilteredData[indexPath.row].item.itemName)"
        
        if investmentFilteredData[indexPath.row].platform.uppercased() == "PC"
        {
            cell.platformIcon.image = UIImage(named: "PC Icon")
        }
        else if investmentFilteredData[indexPath.row].platform.uppercased() == "PS4"
        {
            cell.platformIcon.image = UIImage(named: "PS4 Icon")
        }
        else if investmentFilteredData[indexPath.row].platform.uppercased() == "SWITCH"
        {
            cell.platformIcon.image = UIImage(named: "Switch Icon")
        }
        else if investmentFilteredData[indexPath.row].platform.uppercased() == "XBOX"
        {
            cell.platformIcon.image = UIImage(named: "Xbox Icon")
        }
        else
        {
            cell.platformIcon.image = nil
        }
        
        if investmentFilteredData[indexPath.row].quantity > 1
        {
            cell.totalBoughtSpentLabel.text = "Bought \(investmentFilteredData[indexPath.row].quantity) for \(investmentFilteredData[indexPath.row].boughtFor) each, Total: \(investmentFilteredData[indexPath.row].quantity * investmentFilteredData[indexPath.row].boughtFor)"
        }
        else
        {
            cell.totalBoughtSpentLabel.text = "Bought \(investmentFilteredData[indexPath.row].quantity) for \(investmentFilteredData[indexPath.row].boughtFor)"
        }
        
        let priceRange = investmentFilteredData[indexPath.row].item.getColourPrice(colour: investmentFilteredData[indexPath.row].colour.uppercased(), onPlatform: investmentFilteredData[indexPath.row].platform.uppercased())
        //there shouldnt be any nil values as it gets filtered out during the adding process
        cell.currentPriceLabel.text = "Current Price: \(priceRange![0]) - \(priceRange![1])"
        
        cell.totalNowLabel.text = "Total if Sold Now: \(priceRange![0] * investmentFilteredData[indexPath.row].quantity) - \(priceRange![1] * investmentFilteredData[indexPath.row].quantity)"
        
        let totalSpent = investmentFilteredData[indexPath.row].quantity * investmentFilteredData[indexPath.row].boughtFor
        let profitLowerBound = priceRange![0] * investmentFilteredData[indexPath.row].quantity - totalSpent
        let profitUpperBound = priceRange![1] * investmentFilteredData[indexPath.row].quantity - totalSpent
        
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
        
        cell.profitLabel.text = "Profit/Loss: \(profitLowerBoundString) - \(profitUpperBoundString)"
        cell.amountStepper.value = Double(investmentFilteredData[indexPath.row].quantity)
        
        //we need to find the position of the investment's id in the actual investments
        var investmentPosition: Int! = nil
        var i = 0
        while i != investments.count
        {
            if investmentFilteredData[indexPath.row].id == investments[i].id
            {
                investmentPosition = i
            }
            i += 1
        }
        
        cell.tag = investmentPosition!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension investmentOverview: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        investmentFilteredData = []
        for investment in investments
        {
            if investment.item.itemName.uppercased().contains(searchText.uppercased())
            {
                investmentFilteredData.append(investment)
            }
        }
        if searchText == ""
        {
            investmentFilteredData = investments
        }
        
        self.tableView.reloadData()
    }
}
