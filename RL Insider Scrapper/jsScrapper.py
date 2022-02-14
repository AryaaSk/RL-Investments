#need a new scrapper since rl insider now uses dynamic javascript

import dryscrape
from bs4 import BeautifulSoup
from dataclasses import dataclass
import pyrebase

@dataclass
class prices:
    default: [int, int]
    black: [int, int]
    white: [int, int]
    grey: [int, int]
    crimson: [int, int]
    pink: [int, int]
    cobalt: [int, int]
    skyBlue: [int, int]
    burntSienna: [int, int]
    saffron: [int, int]
    lime: [int, int]
    forestGreen: [int, int]
    orange: [int, int]
    purple: [int, int]

@dataclass
class item:
    name: str
    pc_prices: prices
    xbox_prices: prices
    ps4_prices: prices
    switch_prices: prices

url = 'https://rl.insider.gg/en/pc'
session = dryscrape.Session()
session.visit(url)
response = session.body()
print(response)

#once i have the data i need to change it back to the old data structure since the old app is built on it.
#Execute this function 1 or 2 times per day
