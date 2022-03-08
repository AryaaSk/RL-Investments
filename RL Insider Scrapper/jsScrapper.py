#need a new scrapper since rl insider now uses dynamic javascript
from requests_html import HTMLSession

url = 'https://rl.insider.gg/en/pc'
#url = 'http://127.0.0.1:8080'
session = HTMLSession()

script = """
    () => {

        window.resizeTo(1920, 1080);
        location.reload();


         return {
            width: window.innerWidth,
            height: window.innerHeight,
        }
    
    }
"""

r = session.get(url)
print(r.html.html)

print(r.html.render(sleep=5, timeout=1000, script=script)) #to apply the zoom

#RL Insider redirects to mobile site when the width is less than 1250px
#Request HTML sends the request in a browser that is 800px X 600px, I need to change that

print(r.html.html)





#once i have the data i need to change it back to the old data structure since the old app is built on it.
#Execute this function 1 or 2 times per day




"""
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

class item:
    name: str
    pc_prices: prices
    xbox_prices: prices
    ps4_prices: prices
    switch_prices: prices
    def __init__(self, name, pc_prices, xbox_prices, ps4_prices, switch_prices):
        self.name = name
        self.pc_prices = pc_prices
        self.xbox_prices = xbox_prices
        self.ps4_prices = ps4_prices
        self.switch_prices = switch_prices
"""
