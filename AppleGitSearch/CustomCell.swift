//
//  CustomCell.swift
//  AppleGitSearch
//
//  Created by Peter Zeman on 13.5.18.
//  Copyright © 2018 Peter Zeman. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet var full_name: UILabel!
    @IBOutlet var updated_at: UILabel!
    @IBOutlet var descriptionText: UILabel!
    @IBOutlet var stargazers_count: UILabel!
    @IBOutlet var avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        
    }
    
}
