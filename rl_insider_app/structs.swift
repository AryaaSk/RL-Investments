//
//  structs.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 08/05/2021.
//

import Foundation

struct decodingitems: Codable
{
    let items: [decodingitem]
}
struct decodingitem: Codable
{
    let itemName: String
    let itemPriceRange: prices
}
struct prices: Codable
{
    let pc_price: [Int]?
    let ps4_price: [Int]?
    let switch_price: [Int]?
    let xbox_price: [Int]?
    
    let black_pc_price: [Int]?
    let black_ps4_price: [Int]?
    let black_switch_price: [Int]?
    let black_xbox_price: [Int]?
    
    let white_pc_price: [Int]?
    let white_ps4_price: [Int]?
    let white_switch_price: [Int]?
    let white_xbox_price: [Int]?
    
    let grey_pc_price: [Int]?
    let grey_ps4_price: [Int]?
    let grey_switch_price: [Int]?
    let grey_xbox_price: [Int]?
    
    let crimson_pc_price: [Int]?
    let crimson_ps4_price: [Int]?
    let crimson_switch_price: [Int]?
    let crimson_xbox_price: [Int]?
    
    let pink_pc_price: [Int]?
    let pink_ps4_price: [Int]?
    let pink_switch_price: [Int]?
    let pink_xbox_price: [Int]?
    
    let cobalt_pc_price: [Int]?
    let cobalt_ps4_price: [Int]?
    let cobalt_switch_price: [Int]?
    let cobalt_xbox_price: [Int]?
    
    let skyBlue_pc_price: [Int]?
    let skyBlue_ps4_price: [Int]?
    let skyBlue_switch_price: [Int]?
    let skyBlue_xbox_price: [Int]?
    
    let burntSienna_pc_price: [Int]?
    let burntSienna_ps4_price: [Int]?
    let burntSienna_switch_price: [Int]?
    let burntSienna_xbox_price: [Int]?
    
    let saffron_pc_price: [Int]?
    let saffron_ps4_price: [Int]?
    let saffron_switch_price: [Int]?
    let saffron_xbox_price: [Int]?
    
    let lime_pc_price: [Int]?
    let lime_ps4_price: [Int]?
    let lime_switch_price: [Int]?
    let lime_xbox_price: [Int]?
    
    let forestGreen_pc_price: [Int]?
    let forestGreen_ps4_price: [Int]?
    let forestGreen_switch_price: [Int]?
    let forestGreen_xbox_price: [Int]?
    
    let orange_pc_price: [Int]?
    let orange_ps4_price: [Int]?
    let orange_switch_price: [Int]?
    let orange_xbox_price: [Int]?
    
    let purple_pc_price: [Int]?
    let purple_ps4_price: [Int]?
    let purple_switch_price: [Int]?
    let purple_xbox_price: [Int]?
}

struct investmentItem: Codable
{
    var item: decodingitem
    var colour: String
    var quantity: Int
    var boughtFor: Int
    var platform: String
}
