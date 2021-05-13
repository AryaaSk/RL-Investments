//
//  dataManagment.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 08/05/2021.
//

import Foundation

var platform = UserDefaults.standard.string(forKey: "platform") ?? "PC"

var investments: [investmentItem] = getSavedInvestments()
var groups: [investmentGroup] = getSavedGroups()
var items: [decodingitem] = []
var filteredData: [decodingitem] = []

//MARK:- ADD NEW:
//Select Item:
var selectedItem: decodingitem? = nil
var selectedColour: String? = nil
var selectedPlatform = platform
var selectedAmount = 1
var priceBoughtFor = 0
var selectedID = 0

//Delete Item
var cellTag = 0

//Edit Item
var editingMode = false
