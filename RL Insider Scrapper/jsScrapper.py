#Using pyppeteer to get data from RL Insider, and render Javascript
#For now Ill just use sample data since I dont want to wait 50 seconds everytime to run the program

from bs4 import BeautifulSoup

f = open("pcPricesSmall.html", "r")
pcPrices = f.read()
f.close()

f = open("ps4PricesSmall.html", "r")
ps4Prices = f.read()
f.close()


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

def parseTable(table, platform):
    for row in table:
        itemName = row.find("div", {"class": "fnl"}).text
        
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

        print(itemName)
        print(default)

        #itemObject = 

        #then add all these to the platformList
        #if platform == "pc"
            


    
items = []

pcSoup = BeautifulSoup(pcPrices, 'html.parser')
tableContent = getData(pcSoup, "paintedBMDecalsPrices")
parsedData = parseTable(tableContent, "pc") #now that we have the data, we just need to parse it

#print(parsedData[0])

pcItems = {}
ps4Items = {}
xboxItems = {}
switchItems = {}

#I can save the data as a dictionary for each platform, with the key being the itemID
#Then at the very end I can just combine all the data into 1 item, since it is a dictionary I can go straight to the wanted item instead of having to search the entire array
#I just need to save all the itemIDs in1 array as well















