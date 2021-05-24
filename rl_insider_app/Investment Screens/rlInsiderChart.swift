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
        
        //now we construct the url
        if investments[cellTag].platform.uppercased() != "PS4"
        {
            urlString = """
                https://rl.insider.gg/en/\(investments[cellTag].platform.uppercased().lowercased())/\(investments[cellTag].item.itemUrlName)/\(insiderColours[i])
                """
        }
        else
        {
            urlString = """
                https://rl.insider.gg/en/psn/\(investments[cellTag].item.itemUrlName)/\(insiderColours[i])
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
