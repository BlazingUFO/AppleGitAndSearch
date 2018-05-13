//
//  Repo.swift
//  AppleGitSearch
//
//  Created by Peter Zeman on 12.5.18.
//  Copyright © 2018 Peter Zeman. All rights reserved.
//

import Foundation

struct RepoSearch {
    let id: Int
    let name: String
    let descriptionString: String
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
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateToReturn = dateFormatter.date(from: updated_at)!
        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
        dateFormatter.locale = tempLocale
        self.updated_at = dateFormatter.string(from: dateToReturn)
        self.id = id
        self.name = name
        self.descriptionString = description
        self.html_url = html_url
        self.avatar_url = avatar_url
        self.stargazers_count = stargazers_count
    }
    
    
    init(_ id: Int, _ name: String, _ description: String, _ html_url: String, _ avatar_url: String, _ updated_at: String, _ stargazers_count: Int) {
        self.id = id
        self.name = name
        self.descriptionString = description
        self.html_url = html_url
        self.avatar_url = avatar_url
        self.updated_at = updated_at
        self.stargazers_count = stargazers_count
    }
}

