//
//  Repo.swift
//  AppleGitSearch
//
//  Created by Peter Zeman on 12.5.18.
//  Copyright © 2018 Peter Zeman. All rights reserved.
//

import Foundation

struct Repo {
    let id: Int
    let name: String
    let description: String
    let html_url: String
    let avatar_url: String
    let updated_at: String
    let stargazers_count: Int
    
    init?(object: [String: Any]) {
        guard let id = object["id"] as? Int,
            let name = object["full_name"] as? String,
            let description = object["description"] as? String,
            let html_url = object["html_url"] as? String,
            let updated_at = object["updated_at"] as? String,
            let stargazers_count = object["stargazers_count"] as? Int,
            let owner = object["owner"] as? [String: Any],
            let avatar_url = owner["avatar_url"] as? String
            else {
                return nil
        }
        self.id = id
        self.name = name
        self.description = description
        self.html_url = html_url
        self.avatar_url = avatar_url
        self.updated_at = updated_at
        self.stargazers_count = stargazers_count
    }
    
    init(_ id: Int, _ name: String, _ description: String, _ html_url: String, _ avatar_url: String, _ updated_at: String, _ stargazers_count: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.html_url = html_url
        self.avatar_url = avatar_url
        self.updated_at = updated_at
        self.stargazers_count = stargazers_count
    }
}

