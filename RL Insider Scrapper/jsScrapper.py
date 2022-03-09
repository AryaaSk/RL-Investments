#Using pyppeteer to get data from RL Insider, and render Javascript
import asyncio
from pyppeteer import launch #pip install pyppeteer
import time

async def main():
    browser = await launch(headless=True) #if you want to see it you can set headless=False
    page = await browser.newPage()
    await page.setViewport({ "width": 1920, "height": 1080}) #change the viewport so that the site doesn't redirect to mobile

    waitTime = 50
    
    await page.goto('https://rl.insider.gg/en/pc')
    time.sleep(waitTime) #to try and wait for the all the items to load
    pcHTML = await page.evaluate('''() => {
        return document.body.innerHTML;
    }''')

    await page.goto('https://rl.insider.gg/en/ps4')
    time.sleep(waitTime) #to try and wait for the all the items to load
    ps4HTML = await page.evaluate('''() => {
        return document.body.innerHTML;
    }''')

    await page.goto('https://rl.insider.gg/en/xbox')
    time.sleep(waitTime) #to try and wait for the all the items to load
    xboxHTML = await page.evaluate('''() => {
        return document.body.innerHTML;
    }''')

    await page.goto('https://rl.insider.gg/en/switch')
    time.sleep(waitTime) #to try and wait for the all the items to load
    switchHTML = await page.evaluate('''() => {
        return document.body.innerHTML;
    }''')

    await browser.close()
    
    return {"pc" : pcHTML, "ps4": ps4HTML, "xbox": xboxHTML, "switch" : switchHTML}

HTMLResponse = asyncio.get_event_loop().run_until_complete(main()) #this line just runs the function

print("Got data from RLInsider")

pcPrices = HTMLResponse["pc"]
ps4Prices = HTMLResponse["ps4"]
xboxPrices = HTMLResponse["xbox"]
switchPrices = HTMLResponse["switch"]

#Algorithm:
from bs4 import BeautifulSoup

class prices:
    default: list[int]
    black: list[int]
    white: list[int]
    grey: list[int]
    crimson: list[int]
    pink: list[int]
    cobalt: list[int]
    skyBlue: list[int]
    burntSienna: list[int]
    saffron: list[int]
    lime: list[int]
    forestGreen: list[int]
    orange: list[int]
    purple: list[int]
    def __init__(self, default, black, white, grey, crimson, pink, cobalt, skyBlue, burntSienna, saffron, lime, forestGreen, orange, purple):
        self.default = default
        self.black = black
        self.white = white
        self.grey = grey
        self.crimson = crimson
        self.pink = pink
        self.cobalt = cobalt
        self.skyBlue = skyBlue
        self.burntSienna = burntSienna
        self.saffron = saffron
        self.lime = lime
        self.forestGreen = forestGreen
        self.orange = orange
        self.purple = purple

class itemData:
    itemID: str
    itemName: str
    def __init__(self, ID, name):
        self.itemID = ID
        self.itemName = name


items = []

pcItems = {}
ps4Items = {}
xboxItems = {}
switchItems = {}

#I can save the data as a dictionary for each platform, with the key being the itemID
#Then at the very end I can just combine all the data into 1 item, since it is a dictionary I can go straight to the wanted item instead of having to search the entire array
#I just need to save all the itemIDs in1 array as well

def getData(soup, containerID):
    table = soup.find(id=containerID) #get container, e.g. paintedBMDecalsPrices
    tableContent = table.find_all("tr") #now find the individual items

    #remove the (class=emptyCell)s
    i = 0
    while i != len(tableContent):
        cellString = str(tableContent[i])
        cellStringSoup = BeautifulSoup(cellString, 'html.parser') #converting it into a soup and checking if it contains the class "emptyCell"
        isEmpty = cellStringSoup.find("tr", {"class": "emptyCell"})
        if isEmpty != None:
            del tableContent[i]
        else:
            i += 1
            
    return tableContent


import copy
def parseTable(table, platform, getItemData):
    for row in table:
        itemName = row.find("div", {"class": "fnl"}).text

        #also need to get the itemID
        rowOuter = copy.copy(row)
        rowOuter.string = ''
        #now just need to get itemID from the row's outerHTML
        rowOuter = str(rowOuter)

        #split it based on ". then just get middle value
        rowOuter = rowOuter.split('"')
        itemID = rowOuter[1] #the id is the middle value
        
        tableData = row.findAll("td") #this is all the data in the row, the first is the itemName slot, then it goes onto the colours
        del tableData[0] #remove the name cell

        #prices
        priceStrings = []
        for i in range(0, 14):
            try:
                currentPrice = tableData[i].text #parse this price
                currentPrice = currentPrice.replace("\u200a", "") #removing random unicode letters
                currentPrice = currentPrice.replace("\u2003", "")
                
                k = False  #k stands for thousand
                if currentPrice[len(currentPrice) - 1] == "k":
                    k = True
                    currentPrice = currentPrice[:-1] #deleting the k at the end of the numbers

                splitPrice = currentPrice.split("-")
                num1 = float(splitPrice[0])
                if k == True:
                    num1 = num1 * 1000
                num2 = float(splitPrice[1])
                if k == True:
                    num2 = num2 * 1000
                
                priceStrings.append([int(num1), int(num2)])
            except Exception as e:
                priceStrings.append(None)
        
        #now just put those prices from the strings into their specific variable:
        default = priceStrings[0]
        black = priceStrings[1]
        white  = priceStrings[2]
        grey =  priceStrings[3]
        crimson =  priceStrings[4]
        pink =  priceStrings[5]
        cobalt =  priceStrings[6]
        skyBlue =  priceStrings[7]
        burntSienna =  priceStrings[8]
        saffron =  priceStrings[9]
        lime =  priceStrings[10]
        forestGreen =  priceStrings[11]
        orange =  priceStrings[12]
        purple =  priceStrings[13]

        itemObject = prices(default, black, white, grey, crimson, pink, cobalt, skyBlue, burntSienna, saffron, lime, forestGreen, orange, purple)

        #then add all these to the platformList
        if platform == "pc":
            pcItems[itemID] = itemObject
        elif platform == "ps4":
            ps4Items[itemID] = itemObject
        elif platform == "xbox":
            xboxItems[itemID] = itemObject
        elif platform == "switch":
            switchItems[itemID] = itemObject
            

        if getItemData == True:
            #add it to the items list as well
            items.append(itemData(itemID, itemName))

            

soup = BeautifulSoup(pcPrices, 'html.parser')
tableContent = getData(soup, "itemPricesContainer")
parseTable(tableContent, "pc", True) #now that we have the data, we just need to parse it, and set the getItemData to true as the PC has the most prices for items

soup = BeautifulSoup(ps4Prices, 'html.parser')
tableContent = getData(soup, "itemPricesContainer")
parseTable(tableContent, "ps4", False)

soup = BeautifulSoup(xboxPrices, 'html.parser')
tableContent = getData(soup, "itemPricesContainer")
parseTable(tableContent, "xbox", False)

soup = BeautifulSoup(switchPrices, 'html.parser')
tableContent = getData(soup, "itemPricesContainer")
parseTable(tableContent, "switch", False)

#now that we have all the data, we need to loop through the items array and compile all the data from each price list into 1 list of class
class price:
    pc_price: list[int]
    ps4_price: list[int]
    switch_price: list[int]
    xbox_price: list[int]

    black_pc_price: list[int]
    black_ps4_price: list[int]
    black_switch_price: list[int]
    black_xbox_price: list[int]

    white_pc_price: list[int]
    white_ps4_price: list[int]
    white_switch_price: list[int]
    white_xbox_price: list[int]

    grey_pc_price: list[int]
    grey_ps4_price: list[int]
    grey_switch_price: list[int]
    grey_xbox_price: list[int]

    crimson_pc_price: list[int]
    crimson_ps4_price: list[int]
    crimson_switch_price: list[int]
    crimson_xbox_price: list[int]

    pink_pc_price: list[int]
    pink_ps4_price: list[int]
    pink_switch_price: list[int]
    pink_xbox_price: list[int]

    cobalt_pc_price: list[int]
    cobalt_ps4_price: list[int]
    cobalt_switch_price: list[int]
    cobalt_xbox_price: list[int]

    skyBlue_pc_price: list[int]
    skyBlue_ps4_price: list[int]
    skyBlue_switch_price: list[int]
    skyBlue_xbox_price: list[int]

    burntSienna_pc_price: list[int]
    burntSienna_ps4_price: list[int]
    burntSienna_switch_price: list[int]
    burntSienna_xbox_price: list[int]

    saffron_pc_price: list[int]
    saffron_ps4_price: list[int]
    saffron_switch_price: list[int]
    saffron_xbox_price: list[int]

    lime_pc_price: list[int]
    lime_ps4_price: list[int]
    lime_switch_price: list[int]
    lime_xbox_price: list[int]

    forestGreen_pc_price: list[int]
    forestGreen_ps4_price: list[int]
    forestGreen_switch_price: list[int]
    forestGreen_xbox_price: list[int]

    orange_pc_price: list[int]
    orange_ps4_price: list[int]
    orange_switch_price: list[int]
    orange_xbox_price: list[int]

    purple_pc_price: list[int]
    purple_ps4_price: list[int]
    purple_switch_price: list[int]
    purple_xbox_price: list[int]

    def __init__(self):
        pass #don't want to write an init function for all of these attributes

class Item:
    itemName: str
    itemPriceRange: str
    itemUrlName: str
    def __init__(self, name, priceRange, url):
        self.itemName = name
        self.itemPriceRange  = priceRange
        self.itemUrlName = url


oldItems = [] #this is the list which we parse and send to firebase

for i in items:
    itemName = i.itemName
    itemID = i.itemID
    
    pc = pcItems[itemID] #the prices
    ps4 = ps4Items[itemID]
    xbox = xboxItems[itemID]
    switch = switchItems[itemID]

    newPrice = price()

    newPrice.pc_price = pc.white
    newPrice.ps4_price = ps4.default
    newPrice.switch_price = switch.default
    newPrice.xbox_price = xbox.default
    
    newPrice.black_pc_price = pc.black
    newPrice.black_ps4_price = ps4.black
    newPrice.black_switch_price = switch.black
    newPrice.black_xbox_price = xbox.black

    newPrice.white_pc_price = pc.white
    newPrice.white_ps4_price = ps4.white
    newPrice.white_switch_price = switch.white
    newPrice.white_xbox_price = xbox.white

    newPrice.grey_pc_price = pc.grey
    newPrice.grey_ps4_price = ps4.grey
    newPrice.grey_switch_price = switch.grey
    newPrice.grey_xbox_price = xbox.grey

    newPrice.crimson_pc_price = pc.crimson
    newPrice.crimson_ps4_price = ps4.crimson
    newPrice.crimson_switch_price = switch.crimson
    newPrice.crimson_xbox_price = xbox.crimson

    newPrice.pink_pc_price = pc.pink
    newPrice.pink_ps4_price = ps4.pink
    newPrice.pink_switch_price = switch.pink
    newPrice.pink_xbox_price = xbox.pink

    newPrice.cobalt_pc_price = pc.cobalt
    newPrice.cobalt_ps4_price = ps4.cobalt
    newPrice.cobalt_switch_price = switch.cobalt
    newPrice.cobalt_xbox_price = xbox.cobalt

    newPrice.skyBlue_pc_price = pc.skyBlue
    newPrice.skyBlue_ps4_price = ps4.skyBlue
    newPrice.skyBlue_switch_price = switch.skyBlue
    newPrice.skyBlue_xbox_price = xbox.skyBlue

    newPrice.burntSienna_pc_price = pc.burntSienna
    newPrice.burntSienna_ps4_price = ps4.burntSienna
    newPrice.burntSienna_switch_price = switch.burntSienna
    newPrice.burntSienna_xbox_price = xbox.burntSienna

    newPrice.saffron_pc_price = pc.saffron
    newPrice.saffron_ps4_price = ps4.saffron
    newPrice.saffron_switch_price = switch.saffron
    newPrice.saffron_xbox_price = xbox.saffron

    newPrice.lime_pc_price = pc.lime
    newPrice.lime_ps4_price = ps4.lime
    newPrice.lime_switch_price = switch.lime
    newPrice.lime_xbox_price = xbox.lime

    newPrice.forestGreen_pc_price = pc.forestGreen
    newPrice.forestGreen_ps4_price = ps4.forestGreen
    newPrice.forestGreen_switch_price = switch.forestGreen
    newPrice.forestGreen_xbox_price = xbox.forestGreen

    newPrice.orange_pc_price = pc.orange
    newPrice.orange_ps4_price = ps4.orange
    newPrice.orange_switch_price = switch.orange
    newPrice.orange_xbox_price = xbox.orange

    newPrice.purple_pc_price = pc.purple
    newPrice.purple_ps4_price = ps4.purple
    newPrice.purple_switch_price = switch.purple
    newPrice.purple_xbox_price = xbox.purple

    #finally compile all this into a item()
    oldItems.append(Item(itemName, newPrice, itemName))


print("Parsed Data")

#stringify the oldItems list
import json

jsonList = []
for item in oldItems:
    newItem = Item(item.itemName, item.itemPriceRange.__dict__, item.itemName) #need to convert prices to dictionary as the json.dumps() can't convert an object to json
    JSON = json.dumps(newItem.__dict__)
    jsonList.append(JSON)
    
JSONString = """
                {"items" : [ 
                 """
for json in jsonList:
        JSONString = JSONString + json + ","
JSONString = JSONString[:-1] #remove the final ","
JSONString = JSONString + "]}"

print(JSONString)

#upload to firebase
import pyrebase
config = {
  "apiKey": "apiKey",
  "authDomain": "rlinsiderprices.firebaseapp.com",
  "databaseURL": "https://rlinsiderprices-default-rtdb.firebaseio.com",
  "storageBucket": "rlinsiderprices.appspot.com"
}

firebase = pyrebase.initialize_app(config)

db = firebase.database()
db.child("prices").set(JSONString)
    















