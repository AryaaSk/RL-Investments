#Using pyppeteer to get data from RL Insider, and render Javascript
#For now Ill just use sample data since I dont want to wait 50 seconds everytime to run the program

from bs4 import BeautifulSoup

f = open("pcPricesSmall.html", "r")
pcPrices = f.read()
f.close()

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
        itemID = "insert id here"
        
        tableData = row.findAll("td") #this is all the data in the row, the first is the itemName slot, then it goes onto the colours
        del tableData[0] #remove the name cell

        #prices
        priceStrings = []
        for i in range(0, 14):
            try:
                currentPrice = tableData[i].text #parse this price
                
                k = False  #k stands for thousand
                if currentPrice[len(currentPrice) - 1] == "k":
                    k = True
                    currentPrice = currentPrice[:-1] #deleting the k at the end of the numbers

                currentPrice = currentPrice.replace("\u200a", "") #removing random unicode letters
                currentPrice = currentPrice.replace("\u2003", "")

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

        if getItemData == True:
            #add it to the items list as well
            items.append(itemData(itemID, itemName))

            

pcSoup = BeautifulSoup(pcPrices, 'html.parser')
tableContent = getData(pcSoup, "itemPricesContainer")
parseTable(tableContent, "pc", True) #now that we have the data, we just need to parse it, and set the getItemData to true as the PC has the most prices for items

print(items[len(items) - 1])
print(pcItems)

#I can save the data as a dictionary for each platform, with the key being the itemID
#Then at the very end I can just combine all the data into 1 item, since it is a dictionary I can go straight to the wanted item instead of having to search the entire array
#I just need to save all the itemIDs in1 array as well















