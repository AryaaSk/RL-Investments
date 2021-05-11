//
//  initialization.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 09/05/2021.
//

import Foundation
import Firebase

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
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("reloadItems"), object: nil)
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
