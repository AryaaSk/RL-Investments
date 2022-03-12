//
//  rlInsiderChart.swift
//  rl_insider_app
//
//  Created by Aryaa Saravanakumar on 24/05/2021.
//

import UIKit
import WebKit

class rlInsiderChart: UIViewController, WKNavigationDelegate{

    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let colours = ["Default", "Black", "Titanium White", "Grey", "Crimson", "Pink", "Cobalt", "Sky Blue", "Burnt Sienna", "Saffron", "Lime", "Forest Green", "Orange", "Purple"]
        let insiderColours = ["", "black", "white", "grey", "crimson", "pink", "cobalt", "sblue", "sienna", "saffron", "lime", "fgreen", "orange", "purple"]
        
        //we find what colour the item is, then use the index to get the same colour from insiderColours
        var i = 0
        while i != colours.count
        {
            if colours[i] == investments[cellTag].colour
            {
                break
            }
            i += 1
        }
        
        var urlString = ""
        let itemURLName = investments[cellTag].item.itemUrlName.replacingOccurrences(of: " ", with: "_") //need to fix this a little bit since the new algorithm seems to not be working
        
        //now we construct the url
        if investments[cellTag].platform.uppercased() != "PS4"
        {
            urlString = """
                https://rl.insider.gg/en/\(investments[cellTag].platform.uppercased().lowercased())/\(itemURLName)/\(insiderColours[i])
                """
        }
        else
        {
            urlString = """
                https://rl.insider.gg/en/psn/\(itemURLName)/\(insiderColours[i])
                """
        }
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.backgroundColor = UIColor(red: 21, green: 26, blue: 28, alpha: 1)
        
        let url = URL(string: urlString)
        webView.load(URLRequest(url: url!))
        
        print(urlString)
        
        
    }
}
