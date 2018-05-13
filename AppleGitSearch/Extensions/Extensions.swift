//
//  Extensions.swift
//  AppleGitSearch
//
//  Created by Peter Zeman on 13.5.18.
//  Copyright © 2018 Peter Zeman. All rights reserved.
//

import UIKit
import ObjectiveC


extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "something went wrong")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}

