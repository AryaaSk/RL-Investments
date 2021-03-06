//
//  functions.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 09/05/2021.
//

import Foundation
import UIKit

//Userdefaults
func saveInvestmentsData()
{
    investmentFilteredData = investments
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(investments) {
        UserDefaults.standard.set(encoded, forKey: "Investments")
    }
    
}
func getSavedInvestments() -> [investmentItem]
{
    if let investmentData = UserDefaults.standard.object(forKey: "Investments") as? Data {
        let decoder = JSONDecoder()
        if let loadedInvestments = try? decoder.decode([investmentItem].self, from: investmentData) {
            return loadedInvestments
        }
        else
        {
            return []
        }
    }
    else
    {
        return []
    }
}

func saveGroupData()
{
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(groups) {
        UserDefaults.standard.set(encoded, forKey: "groups")
    }
    
}
func getSavedGroups() -> [investmentGroup]
{
    if let investmentData = UserDefaults.standard.object(forKey: "groups") as? Data {
        let decoder = JSONDecoder()
        if let loadedInvestments = try? decoder.decode([investmentGroup].self, from: investmentData) {
            return loadedInvestments
        }
        else
        {
            return []
        }
    }
    else
    {
        return []
    }
}

func updatePlatform()
{
    UserDefaults.standard.set(platform, forKey: "platform")
}

extension decodingitem
{
    func getColourPrice(colour: String, onPlatform: String) -> [Int]?
    {
        if colour.uppercased() == "DEFAULT"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "BLACK"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.black_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.black_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.black_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.black_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "TITANIUM WHITE"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.white_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.white_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.white_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.white_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "GREY"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.grey_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.grey_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.grey_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.grey_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "CRIMSON"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.crimson_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.crimson_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.crimson_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.crimson_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "PINK"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.pink_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.pink_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.pink_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.pink_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "COBALT"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.cobalt_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.cobalt_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.cobalt_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.cobalt_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "SKY BLUE"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.skyBlue_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.skyBlue_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.skyBlue_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.skyBlue_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "BURNT SIENNA"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.burntSienna_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.burntSienna_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.burntSienna_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.burntSienna_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "SAFFRON"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.saffron_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.saffron_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.saffron_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.saffron_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "LIME"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.lime_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.lime_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.lime_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.lime_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "FOREST GREEN"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.forestGreen_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.forestGreen_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.forestGreen_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.forestGreen_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "ORANGE"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.orange_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.orange_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.orange_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.orange_xbox_price
            }
            else
            {
                return nil
            }
        }
        else if colour.uppercased() == "PURPLE"
        {
            if onPlatform.uppercased() == "PC"
            {
                return self.itemPriceRange.purple_pc_price
            }
            else if onPlatform.uppercased() == "PS4"
            {
                return self.itemPriceRange.purple_ps4_price
            }
            else if onPlatform.uppercased() == "SWITCH"
            {
                return self.itemPriceRange.purple_switch_price
            }
            else if onPlatform.uppercased() == "XBOX"
            {
                return self.itemPriceRange.purple_xbox_price
            }
            else
            {
                return nil
            }
        }
        else
        {
            return nil
        }
        
    }
}

func investmentID() -> Int
{
    //just find the highest number and that is our id
    var i = 0
    var returnID = 0
    while i != investments.count
    {
        if investments[i].id >= returnID
        {
            returnID = investments[i].id + 1
        }
        i += 1
    }
    
    return returnID
}

func updateXPlatforms()
{
    UserDefaults.standard.setValue(xPlatData[0], forKey: "platform1")
    UserDefaults.standard.setValue(xPlatData[1], forKey: "platform2")
}

extension UIView {
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        switch edge {
        case .top, .bottom:
            subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            subview.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .top {
                subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            } else {
                subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            }
        case .left, .right:
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .left {
                subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            } else {
                subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            }
        default:
            break
        }
    }
}
