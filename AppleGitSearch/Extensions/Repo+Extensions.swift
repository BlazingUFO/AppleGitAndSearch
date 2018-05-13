//
//  Repo+Extensions.swift
//  AppleGitSearch
//
//  Created by Peter Zeman on 13.5.18.
//  Copyright © 2018 Peter Zeman. All rights reserved.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData

func == (lhs: Repo, rhs: Repo) -> Bool {
    return lhs.id == rhs.id
}

extension Repo : Equatable { }

extension Repo : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return String(id)}
}

extension Repo : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "Repo"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    
    init(entity: T) {
        id = entity.value(forKey: "id") as! Int64
        name = entity.value(forKey: "name") as! String
        descriptionString = entity.value(forKey: "descriptionString") as! String
        html_url = entity.value(forKey: "html_url") as! String
        avatar_url = entity.value(forKey: "avatar_url") as! String
        updated_at = entity.value(forKey: "updated_at") as! String
        stargazers_count = entity.value(forKey: "stargazers_count") as! Int64
    }
    
    init?(object: [String: Any]) {
        guard let id = object["id"] as? Int64,
            let name = object["full_name"] as? String,
            let description = object["description"] as? String,
            let html_url = object["html_url"] as? String,
            let updated_at = object["updated_at"] as? String,
            let stargazers_count = object["stargazers_count"] as? Int64,
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
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(name, forKey: "name")
        entity.setValue(descriptionString, forKey: "descriptionString")
        entity.setValue(html_url, forKey: "html_url")
        entity.setValue(avatar_url, forKey: "avatar_url")
        entity.setValue(updated_at, forKey: "updated_at")
        entity.setValue(stargazers_count, forKey: "stargazers_count")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}

