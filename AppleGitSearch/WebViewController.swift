//
//  WebViewController.swift
//  AppleGitSearch
//
//  Created by Peter Zeman on 12.5.18.
//  Copyright © 2018 Peter Zeman. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    var urlToLoad: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.urlToLoad!)
        if self.urlToLoad != nil{
            let url = URL(string: self.urlToLoad!)
            let req = URLRequest(url: url!)
            self.webView!.load(req)
        }
    }
    
}
