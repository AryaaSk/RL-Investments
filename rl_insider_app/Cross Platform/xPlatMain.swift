//
//  xPlatMain.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 02/06/2021.
//

import UIKit

class xPlatMain: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var searchBar: UISearchBar!
    
    var xPlatItems: [xPlat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("reloadXPlatTableView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadPlatforms"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadItems"), object: nil)
        
        self.title = "\(xPlatData[0]) -> \(xPlatData[1])"
    }
    
    @objc func reloadTableView()
    {
        self.title = "\(xPlatData[0]) -> \(xPlatData[1])"
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        tableView.isHidden = false
        
        tableView.reloadData()
    }
    
    @objc func reload()
    {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        tableView.isHidden = true
        
        //Cycle through all the items and create a new variable called xPlatItems, with the struct
        xPlatItems = []
        
        for item in items
        {
            //now cycle through the colours
            let colours = ["Default", "Black", "Titanium White", "Grey", "Crimson", "Pink", "Cobalt", "Sky Blue", "Burnt Sienna", "Saffron", "Lime", "Forest Green", "Orange", "Purple"]
            for colour in colours
            {
                //first get platform 1 price
                let platform1PriceRange = item.getColourPrice(colour: colour, onPlatform: xPlatData[0]) //this returns a range
                let platform2PriceRange = item.getColourPrice(colour: colour, onPlatform: xPlatData[1])
                
                if platform1PriceRange == nil || platform2PriceRange == nil
                {
                    continue
                }
                else
                {
                    let platform1Price = Float(platform1PriceRange![0] + platform1PriceRange![1] / 2)
                    let platform2Price = Float(platform2PriceRange![0] + platform2PriceRange![1] / 2)
                    let percentage = platform2Price / platform1Price * 100
                    
                    xPlatItems.append(xPlat(itemName: item.itemName, itemColour: colour, percentageIncrease: percentage, platform1Price: platform1PriceRange!, platform2Price: platform2PriceRange!))
                }
            }
        }
        
        DispatchQueue.main.async {
            //now we just sort the items
            var oldList = self.xPlatItems
            self.xPlatItems = []
            while 0 != oldList.count
            {
                //find the lowest number
                var highestIncrease = 0
                var i = 0
                while i != oldList.count
                {
                    if oldList[i].percentageIncrease >= oldList[highestIncrease].percentageIncrease
                    {
                        highestIncrease = i
                    }
                    i += 1
                }
                
                self.xPlatItems.append(oldList[highestIncrease])
                oldList.remove(at: highestIncrease)
            }
            
            NotificationCenter.default.post(Notification(name: Notification.Name("reloadXPlatTableView")))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        tableView.isHidden = true
        
        if haveLoaded == true
        {
            reload()
        }
    }
    
    struct xPlat
    {
        let itemName: String
        let itemColour: String
        let percentageIncrease: Float
        let platform1Price: [Int]
        let platform2Price: [Int]
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "settings", sender: self)
    }
    
}

extension xPlatMain: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xPlatItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let percentageSimple = Decimal(Int(round(10*xPlatItems[indexPath.row].percentageIncrease))/10)
        
        cell.textLabel?.text = "\(xPlatItems[indexPath.row].itemColour) \(xPlatItems[indexPath.row].itemName): \(percentageSimple)%"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let xPlatitem = xPlatItems[indexPath.row]
        
        var message = ""
        message = message + "\(xPlatData[0]) Price: \(xPlatitem.platform1Price) \n"
        message = message + "\(xPlatData[1]) Price: \(xPlatitem.platform2Price)"
        
        let alert = UIAlertController(title: xPlatitem.itemName, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension xPlatMain: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
