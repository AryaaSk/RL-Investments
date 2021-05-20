from bs4 import BeautifulSoup
import requests
from dataclasses import asdict, dataclass
import dataclasses, json
import pyrebase
from dacite import from_dict

class EnhancedJSONEncoder(json.JSONEncoder):
        def default(self, o):
            if dataclasses.is_dataclass(o):
                return dataclasses.asdict(o)
            return super().default(o)

url = 'https://rl.insider.gg/en/pc'
r = requests.get(url)
soup = BeautifulSoup(r.content, 'html.parser')

items = []
extraWords = ""

@dataclass
class unparsedPrice:
        defaultPrice: str
        blackPrice: str
        whitePrice: str
        greyPrice: str
        crimsonPrice: str
        pinkPrice: str
        cobaltPrice: str
        skyBluePrice: str
        burntSiennaPrice: str
        saffronPrice: str
        limePrice: str
        forestGreenPrice: str
        orangePrice: str
        purplePrice: str

@dataclass
class Item:
    itemName: str
    itemPriceRange: str
    
@dataclass
class price:
    pc_price: [int, int]
    ps4_price: [int, int]
    switch_price: [int, int]
    xbox_price: [int, int]

    black_pc_price: [int, int]
    black_ps4_price: [int, int]
    black_switch_price: [int, int]
    black_xbox_price: [int, int]

    white_pc_price: [int, int]
    white_ps4_price: [int, int]
    white_switch_price: [int, int]
    white_xbox_price: [int, int]

    grey_pc_price: [int, int]
    grey_ps4_price: [int, int]
    grey_switch_price: [int, int]
    grey_xbox_price: [int, int]

    crimson_pc_price: [int, int]
    crimson_ps4_price: [int, int]
    crimson_switch_price: [int, int]
    crimson_xbox_price: [int, int]

    pink_pc_price: [int, int]
    pink_ps4_price: [int, int]
    pink_switch_price: [int, int]
    pink_xbox_price: [int, int]

    cobalt_pc_price: [int, int]
    cobalt_ps4_price: [int, int]
    cobalt_switch_price: [int, int]
    cobalt_xbox_price: [int, int]

    skyBlue_pc_price: [int, int]
    skyBlue_ps4_price: [int, int]
    skyBlue_switch_price: [int, int]
    skyBlue_xbox_price: [int, int]

    burntSienna_pc_price: [int, int]
    burntSienna_ps4_price: [int, int]
    burntSienna_switch_price: [int, int]
    burntSienna_xbox_price: [int, int]

    saffron_pc_price: [int, int]
    saffron_ps4_price: [int, int]
    saffron_switch_price: [int, int]
    saffron_xbox_price: [int, int]

    lime_pc_price: [int, int]
    lime_ps4_price: [int, int]
    lime_switch_price: [int, int]
    lime_xbox_price: [int, int]

    forestGreen_pc_price: [int, int]
    forestGreen_ps4_price: [int, int]
    forestGreen_switch_price: [int, int]
    forestGreen_xbox_price: [int, int]

    orange_pc_price: [int, int]
    orange_ps4_price: [int, int]
    orange_switch_price: [int, int]
    orange_xbox_price: [int, int]

    purple_pc_price: [int, int]
    purple_ps4_price: [int, int]
    purple_switch_price: [int, int]
    purple_xbox_price: [int, int]
    
def convert_to_list(string):
    List = []
    for letter in string:
        List.append(letter)
    return List

def convert_to_string(List):
    string = ""
    for item in List:
        string = string + item
    return string
    
def remove_whitespace(List):
    i = 0
    while i != len(List):
        if List[i] == ' ':
            del List[i]
        else:
            i += 1
    return List

def parseprice(unparsed):
    #first convert all to a list
    List = convert_to_list(unparsed)
    List = remove_whitespace(List)

    if List == []:
            return [None, None, None, None]
    #we also need to check if there is "no hover", this means the price is nil
    noHover = False
    i = 0
    while i != len(List):
        if len(List) - 7 >= i:
            if List[i] + List[i + 1] + List[i + 2] + List[i + 3] + List[i + 4] + List[i + 5] + List[i + 6] == "noHover":
                noHover = True
        i += 1
    
    if noHover == True:
        return [None, None, None, None]
    else:
        pcPrices = [None, None]
        ps4Prices = [None, None]
        switchPrices = [None, None]
        xboxPrices = [None, None]
        
        #go until we find "data"
        i = 0
        while List[i] + List[i + 1] + List[i + 2] + List[i + 3] != "data":
            del List[i]
        
        #delete everything upto the letter "k"
        i = 0
        while List[i] != "k":
            del List[i]
        
        #delete first item 3 items to get only "{" at start
        del List[0]
        del List[0]
        del List[0]

        #add everything to a templist until "}"
        tempList = []
        i = 0
        while List[i] != "}":
            tempList.append(List[i])
            i += 1

        tempList.append("}")
        historyList = List
        List = tempList

        i = 0
        while historyList[i] != "h":
            del historyList[i]
        del historyList[0]
        del historyList[0]
        del historyList[0]
        tempList = []
        i = 0
        while historyList[i] != "}":
            tempList.append(historyList[i])
            i += 1
        tempList.append("}")
        historyList = tempList

        #still need to convert lists into price range lists

        #before going through we need to find what platforms have the price
        platforms = []

        i = 0
        while i != (len(List) - 1):
                if List[i] + List[i + 1] == "pc":
                        platforms.append("pc")
                i += 1
        i = 0
        while i != (len(List) - 2):
                if List[i] + List[i + 1] + List[i + 2] == "ps4":
                        platforms.append("ps4")
                i += 1
        i = 0
        while i != (len(List) - 5):
                if List[i] + List[i + 1] + List[i + 2] + List[i + 3] + List[i + 4] + List[i + 5] == "switch":
                        platforms.append("switch")
                i += 1
        i = 0
        while i != (len(List) - 3):
                if List[i] + List[i + 1] + List[i + 2] + List[i + 3] == "xbox":
                        platforms.append("xbox")
                i += 1

        #pc
        if "pc" in platforms:
                i = 0
                while List[i] != "[":
                    del List[i]
                del List[0]
        
                tempString = ""
                i = 0
                while List[i] != ",":
                    tempString = tempString + List[i]
                    del List[i]
                pcPrices[0] = int(tempString)
        
                del List[0] #to delete the comma
        
                tempString = ""
                i = 0
                while List[i] != "]":
                    tempString = tempString + List[i]
                    del List[i]
                pcPrices[1] = int(tempString)
                del List[0]
        else:
                pcPrices = None

        #ps4
        if 'ps4' in platforms:
                i = 0
                while List[i] != "[":
                    del List[i]
                del List[0]

                tempString = ""
                i = 0
                while List[i] != ",":
                    tempString = tempString + List[i]
                    del List[i]
                ps4Prices[0] = int(tempString)

                del List[0] #to delete the comma
        
                tempString = ""
                i = 0
                while List[i] != "]":
                    tempString = tempString + List[i]
                    del List[i]
                ps4Prices[1] = int(tempString)
                del List[0]
        else:
                ps4Prices = None
                
        #switch
        if "switch" in platforms:
                i = 0
                while List[i] != "[":
                    del List[i]
                del List[0]
        
                tempString = ""
                i = 0
                while List[i] != ",":
                    tempString = tempString + List[i]
                    del List[i]
                switchPrices[0] = int(tempString)

                del List[0] #to delete the comma
        
                tempString = ""
                i = 0
                while List[i] != "]":
                    tempString = tempString + List[i]
                    del List[i]
                switchPrices[1] = int(tempString)
                del List[0]
        else:
                switchPrices = None
                
        #xbox
        if "xbox" in platforms:
                i = 0
                while List[i] != "[":
                    del List[i]
                del List[0]

                tempString = ""
                i = 0
                while List[i] != ",":
                    tempString = tempString + List[i]
                    del List[i]
                xboxPrices[0] = int(tempString)

                del List[0] #to delete the comma
        
                tempString = ""
                i = 0
                while List[i] != "]":
                    tempString = tempString + List[i]
                    del List[i]
                xboxPrices[1] = int(tempString)
                del List[0]
        else:
                xboxPrices = None
        
        return [pcPrices, ps4Prices, switchPrices, xboxPrices]

def getItemsinSection(section):
    itemNames = []
    pricesUnparsed = []
    prices = []
    tempSoup = BeautifulSoup(section, 'html.parser')
    itemRows= []
    for text in tempSoup.find_all("tr", class_="itemRow"):
        itemRows.append(str(text))

    #now loop through item rows and get the name and price, check for "no hover" and normal
    for itemRow in itemRows:
            
        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        unparsedPriceStrings = unparsedPrice("", "", "", "", "", "", "", "", "", "", "", "", "", "") #default, black, white, grey, crimson, pink, cobalt, sky blue, burnt sienna, saffron, lime, forest green, orange, purple
        for text in rowSoup.find_all("div", class_="fnl"):
            itemNames.append(text.get_text())
        
        for text in rowSoup.find_all("td", class_="priceDefault priceRange"):
                unparsedPriceStrings.defaultPrice = str(text)
        for text in rowSoup.find_all("td", class_="priceDefault priceRange noHover"):
                unparsedPriceStrings.defaultPrice = str(text)
                
        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceBlack priceRange"):
                 unparsedPriceStrings.blackPrice = str(text)
        for text in rowSoup.find_all("td", class_="priceBlack priceRange noHover"):
                 unparsedPriceStrings.blackPrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceWhite priceRange"):
                 unparsedPriceStrings.whitePrice = str(text)
        for text in rowSoup.find_all("td", class_="priceWhite priceRange noHover"):
                 unparsedPriceStrings.whitePrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceGrey priceRange"):
                 unparsedPriceStrings.greyPrice = str(text)
        for text in rowSoup.find_all("td", class_="priceGrey priceRange noHover"):
                 unparsedPriceStrings.greyPrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceCrimson priceRange"):
                 unparsedPriceStrings.crimsonPrice = str(text)
        for text in rowSoup.find_all("td", class_="priceCrimson priceRange noHover"):
                 unparsedPriceStrings.crimsonPrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="pricePink priceRange"):
                 unparsedPriceStrings.pinkPrice = str(text)
        for text in rowSoup.find_all("td", class_="pricePink priceRange noHover"):
                 unparsedPriceStrings.pinkPrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceCobalt priceRange"):
                 unparsedPriceStrings.cobaltPrice = str(text)
        for text in rowSoup.find_all("td", class_="priceCobalt priceRange noHover"):
                 unparsedPriceStrings.cobaltPrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceSkyBlue priceRange"):
                 unparsedPriceStrings.skyBluePrice = str(text)
        for text in rowSoup.find_all("td", class_="priceSkyBlue priceRange noHover"):
                 unparsedPriceStrings.skyBluePrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceBurntSienna priceRange"):
                 unparsedPriceStrings.burntSiennaPrice = str(text)
        for text in rowSoup.find_all("td", class_="priceBurntSienna priceRange noHover"):
                 unparsedPriceStrings.burntSiennaPrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceSaffron priceRange"):
                 unparsedPriceStrings.saffronPrice = str(text)
        for text in rowSoup.find_all("td", class_="priceSaffron priceRange noHover"):
                 unparsedPriceStrings.saffronPrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceLime priceRange"):
                 unparsedPriceStrings.limePrice = str(text)
        for text in rowSoup.find_all("td", class_="priceLime priceRange noHover"):
                 unparsedPriceStrings.limePrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceForestGreen priceRange"):
                 unparsedPriceStrings.forestGreenPrice = str(text)
        for text in rowSoup.find_all("td", class_="priceForestGreen priceRange noHover"):
                 unparsedPriceStrings.forestGreenPrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="priceOrange priceRange"):
                 unparsedPriceStrings.orangePrice = str(text)
        for text in rowSoup.find_all("td", class_="priceOrange priceRange noHover"):
                 unparsedPriceStrings.orangePrice = str(text)

        rowSoup = BeautifulSoup(itemRow, 'html.parser')
        for text in rowSoup.find_all("td", class_="pricePurple priceRange"):
                 unparsedPriceStrings.purplePrice = str(text)
        for text in rowSoup.find_all("td", class_="pricePurple priceRange noHover"):
                 unparsedPriceStrings.purplePrice = str(text)
        
        pricesUnparsed.append(unparsedPriceStrings)

    #parse prices
    i = 0
    while i != len(pricesUnparsed):
            newPrice = price(None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None)
            defaultPrices = parseprice(pricesUnparsed[i].defaultPrice)
            newPrice.pc_price = defaultPrices[0]
            newPrice.ps4_price = defaultPrices[1]
            newPrice.switch_price = defaultPrices[2]
            newPrice.xbox_price = defaultPrices[3]

            blackPrices = parseprice(pricesUnparsed[i].blackPrice)
            newPrice.black_pc_price = blackPrices[0]
            newPrice.black_ps4_price = blackPrices[1]
            newPrice.black_switch_price = blackPrices[2]
            newPrice.black_xbox_price = blackPrices[3]

            whitePrices = parseprice(pricesUnparsed[i].whitePrice)
            newPrice.white_pc_price = whitePrices[0]
            newPrice.white_ps4_price = whitePrices[1]
            newPrice.white_switch_price = whitePrices[2]
            newPrice.white_xbox_price = whitePrices[3]

            greyPrices = parseprice(pricesUnparsed[i].greyPrice)
            newPrice.grey_pc_price = greyPrices[0]
            newPrice.grey_ps4_price = greyPrices[1]
            newPrice.grey_switch_price = greyPrices[2]
            newPrice.grey_xbox_price = greyPrices[3]

            crimsonPrices = parseprice(pricesUnparsed[i].crimsonPrice)
            newPrice.crimson_pc_price = crimsonPrices[0]
            newPrice.crimson_ps4_price = crimsonPrices[1]
            newPrice.crimson_switch_price = crimsonPrices[2]
            newPrice.crimson_xbox_price = crimsonPrices[3]

            pinkPrices = parseprice(pricesUnparsed[i].pinkPrice)
            newPrice.pink_pc_price = pinkPrices[0]
            newPrice.pink_ps4_price = pinkPrices[1]
            newPrice.pink_switch_price = pinkPrices[2]
            newPrice.pink_xbox_price = pinkPrices[3]

            cobaltPrices = parseprice(pricesUnparsed[i].cobaltPrice)
            newPrice.cobalt_pc_price = cobaltPrices[0]
            newPrice.cobalt_ps4_price = cobaltPrices[1]
            newPrice.cobalt_switch_price = cobaltPrices[2]
            newPrice.cobalt_xbox_price = cobaltPrices[3]

            skyBluePrices = parseprice(pricesUnparsed[i].skyBluePrice)
            newPrice.skyBlue_pc_price = skyBluePrices[0]
            newPrice.skyBlue_ps4_price = skyBluePrices[1]
            newPrice.skyBlue_switch_price = skyBluePrices[2]
            newPrice.skyBlue_xbox_price = skyBluePrices[3]

            burntSiennaPrices = parseprice(pricesUnparsed[i].burntSiennaPrice)
            newPrice.burntSienna_pc_price = burntSiennaPrices[0]
            newPrice.burntSienna_ps4_price = burntSiennaPrices[1]
            newPrice.burntSienna_switch_price = burntSiennaPrices[2]
            newPrice.burntSienna_xbox_price = burntSiennaPrices[3]

            saffronPrices = parseprice(pricesUnparsed[i].saffronPrice)
            newPrice.saffron_pc_price = saffronPrices[0]
            newPrice.saffron_ps4_price = saffronPrices[1]
            newPrice.saffron_switch_price = saffronPrices[2]
            newPrice.saffron_xbox_price = saffronPrices[3]

            limePrices = parseprice(pricesUnparsed[i].limePrice)
            newPrice.lime_pc_price = limePrices[0]
            newPrice.lime_ps4_price = limePrices[1]
            newPrice.lime_switch_price = limePrices[2]
            newPrice.lime_xbox_price = limePrices[3]

            forestGreenPrices = parseprice(pricesUnparsed[i].forestGreenPrice)
            newPrice.forestGreen_pc_price = forestGreenPrices[0]
            newPrice.forestGreen_ps4_price = forestGreenPrices[1]
            newPrice.forestGreen_switch_price = forestGreenPrices[2]
            newPrice.forestGreen_xbox_price = forestGreenPrices[3]

            orangePrices = parseprice(pricesUnparsed[i].orangePrice)
            newPrice.orange_pc_price = orangePrices[0]
            newPrice.orange_ps4_price = orangePrices[1]
            newPrice.orange_switch_price = orangePrices[2]
            newPrice.orange_xbox_price = orangePrices[3]

            purplePrices = parseprice(pricesUnparsed[i].purplePrice)
            newPrice.purple_pc_price = purplePrices[0]
            newPrice.purple_ps4_price = purplePrices[1]
            newPrice.purple_switch_price = purplePrices[2]
            newPrice.purple_xbox_price = purplePrices[3]
            
            prices.append(newPrice)
            i += 1

    #itemnames and prices should be the same length
    tempItems = []
    i = 0
    while i != len(itemNames):
        tempItems.append(Item(itemNames[i] + extraWords, prices[i]))
        i += 1

    return tempItems


#Just going through all the sections
items = []
#section = str(soup.find_all("div", id = "itemPricesContainer"))
sectionSoup = str(soup.find_all("div", id = "paintedBMDecalsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "unpaintedBMDecalsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedGoalExplosionsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedCarsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedWheelsExoticPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedWheelsLimitedPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedWheelsImportPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedWheelsVeryRarePricesContainer"))
extraWords = " (Very Rare)"
items = items + getItemsinSection(sectionSoup)
extraWords = ""
sectionSoup = str(soup.find_all("div", id = "paintedWheelsRarePricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedWheelsUncommonPricesContainer"))
extraWords = " (Uncommon)"
items = items + getItemsinSection(sectionSoup)
extraWords = ""
sectionSoup = str(soup.find_all("div", id = "paintedDecalsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedBoostsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedToppersPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedAntennasPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedTrailsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedBannersPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintedAvatarBordersPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "alpha+BetaPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "unpaintedGoalExplosionsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "unpaintedCarsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "unpaintedWheelsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "unpaintedDecalsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "unpaintedBoostsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "unpaintedToppersPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "unpaintedAntennasPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "unpaintedTrailsPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "unpaintedBannersPricesContainer"))
extraWords = " (Banner)"
items = items + getItemsinSection(sectionSoup)
extraWords = ""
sectionSoup = str(soup.find_all("div", id = "unpaintedAvatarBordersPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "engineAudioPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "giftPacksPricesContainer"))
items = items + getItemsinSection(sectionSoup)
sectionSoup = str(soup.find_all("div", id = "paintFinishesPricesContainer"))
items = items + getItemsinSection(sectionSoup)


jsonList = []
for item in items:
        jsonList.append(json.dumps(item, cls=EnhancedJSONEncoder))

JSONString = """
                {"items" : [ 
                 """
for json in jsonList:
        JSONString = JSONString + json + ","

tempList = convert_to_list(JSONString)
del tempList[-1]
JSONString = convert_to_string(tempList)

JSONString = JSONString + "]}"

tempList = convert_to_list(JSONString)
i = 0
while tempList[i] != "{":
        del tempList[i]
tempList.remove("\n")
list(filter((' ').__ne__, tempList))
JSONString = convert_to_string(tempList)

print(JSONString) #Now we can just upload this to firebase or any other database

config = {
  "apiKey": "apiKey",
  "authDomain": "rlinsiderprices.firebaseapp.com",
  "databaseURL": "https://rlinsiderprices-default-rtdb.firebaseio.com",
  "storageBucket": "rlinsiderprices.appspot.com"
}

firebase = pyrebase.initialize_app(config)

db = firebase.database()
db.child("prices").set(JSONString)
