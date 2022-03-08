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

#and now you can parse the HTMLResponse into ps4, pc, xbox and switch 
f = open("pcHTML.html", "w")
f.write(HTMLResponse["pc"])
f.close()

f = open("ps4HTML.html", "w")
f.write(HTMLResponse["ps4"])
f.close()

f = open("xboxHTML.html", "w")
f.write(HTMLResponse["xbox"])
f.close()

f = open("switchHTML.html", "w")
f.write(HTMLResponse["switch"])
f.close()







