//
//  initialization.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 09/05/2021.
//

import Foundation
import Firebase

var haveLoaded = false

func initializeData()
{
    let ref: DatabaseReference!
    ref = Database.database().reference()

    ref.child("prices").observeSingleEvent(of: .value, with: { (snapshot) in
        
        let value = snapshot.value as! String
        let json = value
        let decoder = JSONDecoder()
        let data = json.data(using: .utf8)
        do
        {
            items = []
            let tempItems = try decoder.decode(decodingitems.self, from: data!)
            
            for item in tempItems.items
            {
                items.append(item)
            }
            filteredData = items
            
            //update all investments
            var i = 0
            while i != investments.count
            {
                var a = 0
                while a != items.count
                {
                    if investments[i].item.itemName == items[a].itemName
                    {
                        investments[i].item = items[a]
                    }
                    a += 1
                }
                i += 1
            }
            saveInvestmentsData()
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("reloadItems"), object: nil)
                haveLoaded = true
            }
        }
        catch
        {
            print(error)
        }
        
    }) { (error) in
        print(error.localizedDescription)
    }

}
